import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secondsight/data/database.dart';
import 'package:secondsight/ui/session_sheet.dart';

void main() {
  testWidgets('adding a session returns day + minutes', (tester) async {
    SessionSheetResult? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showSessionSheet(context);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Add session'), findsOneWidget);
    expect(find.text('Delete'), findsNothing); // no delete when adding

    // Save is disabled until minutes are entered.
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.enterText(find.byType(TextField), '25');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.delete, isFalse);
    expect(result!.durationMinutes, 25);
  });

  testWidgets('editing shows existing values and a delete action', (
    tester,
  ) async {
    final existing = TimeLog(
      id: 'log-1',
      goalId: 'goal-1',
      durationMs: 40 * 60000,
      day: '2026-07-10',
      createdAtUtc: 0,
    );
    SessionSheetResult? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showSessionSheet(context, existing: existing);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Edit session'), findsOneWidget);
    expect(find.text('40'), findsOneWidget); // prefilled minutes
    expect(find.text('Delete'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '55');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(result!.delete, isFalse);
    expect(result!.durationMinutes, 55);
  });

  testWidgets('delete asks for confirmation, then returns a delete result', (
    tester,
  ) async {
    final existing = TimeLog(
      id: 'log-1',
      goalId: 'goal-1',
      durationMs: 10 * 60000,
      day: '2026-07-10',
      createdAtUtc: 0,
    );
    SessionSheetResult? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await showSessionSheet(context, existing: existing);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    final sheetDeleteButton = find.widgetWithText(OutlinedButton, 'Delete');
    final dialogDeleteButton = find.widgetWithText(TextButton, 'Delete');

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(sheetDeleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Delete this session?'), findsOneWidget);
    // Cancel first: sheet should stay open, no result yet.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
    expect(find.text('Edit session'), findsOneWidget);

    await tester.tap(sheetDeleteButton);
    await tester.pumpAndSettle();
    await tester.tap(dialogDeleteButton); // confirm in the dialog
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.delete, isTrue);
  });
}

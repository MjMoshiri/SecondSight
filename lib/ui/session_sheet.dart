import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/database.dart';
import '../data/period.dart';
import 'format.dart';

class SessionSheetResult {
  final String day;
  final int durationMinutes;
  final bool delete;

  const SessionSheetResult({required this.day, required this.durationMinutes})
    : delete = false;

  const SessionSheetResult.delete()
    : day = '',
      durationMinutes = 0,
      delete = true;
}

/// Add or edit a manually-logged session. Pass [existing] to edit (adds a
/// Delete action); omit it to add a new one, defaulting to today.
///
/// With [countGoal] the sheet edits a check-in instead: just a date, no
/// minutes, and the result's durationMinutes is 0.
Future<SessionSheetResult?> showSessionSheet(
  BuildContext context, {
  TimeLog? existing,
  bool countGoal = false,
}) {
  return showModalBottomSheet<SessionSheetResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF161B24),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) =>
        _SessionSheet(existing: existing, countGoal: countGoal),
  );
}

class _SessionSheet extends StatefulWidget {
  final TimeLog? existing;
  final bool countGoal;

  const _SessionSheet({this.existing, required this.countGoal});

  @override
  State<_SessionSheet> createState() => _SessionSheetState();
}

class _SessionSheetState extends State<_SessionSheet> {
  late DateTime _day;
  late final TextEditingController _minutes;

  @override
  void initState() {
    super.initState();
    final log = widget.existing;
    _day = log == null ? DateTime.now() : _parseDay(log.day);
    _minutes = TextEditingController(
      text: log == null ? '' : (log.durationMs ~/ 60000).toString(),
    );
  }

  DateTime _parseDay(String day) {
    final parts = day.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  @override
  void dispose() {
    _minutes.dispose();
    super.dispose();
  }

  bool get _valid => widget.countGoal || (int.tryParse(_minutes.text) ?? 0) > 0;

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _day = picked);
  }

  Future<void> _confirmDelete() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2130),
        title: Text(
          widget.countGoal ? 'Delete this check-in?' : 'Delete this session?',
        ),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFB7185)),
            ),
          ),
        ],
      ),
    );
    if (yes == true && mounted) {
      Navigator.pop(context, const SessionSheetResult.delete());
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.countGoal
                ? (editing ? 'Edit check-in' : 'Add check-in')
                : (editing ? 'Edit session' : 'Add session'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: _pickDay,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    fmtDay(formatDay(_day)),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          if (!widget.countGoal) ...[
            const SizedBox(height: 14),
            TextField(
              controller: _minutes,
              autofocus: !editing,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Minutes',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              if (editing) ...[
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFB7185),
                        side: BorderSide(
                          color: const Color(0xFFFB7185).withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _confirmDelete,
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: goalHues.first,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: !_valid
                        ? null
                        : () => Navigator.pop(
                            context,
                            SessionSheetResult(
                              day: formatDay(_day),
                              durationMinutes: widget.countGoal
                                  ? 0
                                  : int.parse(_minutes.text),
                            ),
                          ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

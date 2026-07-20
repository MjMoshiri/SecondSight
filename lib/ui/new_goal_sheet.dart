import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/period.dart';
import 'format.dart';
import 'segmented_bar.dart';

class NewGoalResult {
  final String name;
  final int targetMinutes;
  final GoalPeriod period;
  final int sections;

  const NewGoalResult({
    required this.name,
    required this.targetMinutes,
    required this.period,
    required this.sections,
  });
}

Future<NewGoalResult?> showNewGoalSheet(BuildContext context) {
  return showModalBottomSheet<NewGoalResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF161B24),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => const _NewGoalSheet(),
  );
}

class _NewGoalSheet extends StatefulWidget {
  const _NewGoalSheet();

  @override
  State<_NewGoalSheet> createState() => _NewGoalSheetState();
}

class _NewGoalSheetState extends State<_NewGoalSheet> {
  final _name = TextEditingController();
  final _minutes = TextEditingController(text: '400');
  GoalPeriod _period = GoalPeriod.weekly;
  int _sections = 1;

  @override
  void dispose() {
    _name.dispose();
    _minutes.dispose();
    super.dispose();
  }

  bool get _valid =>
      _name.text.trim().isNotEmpty && (int.tryParse(_minutes.text) ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    final accent = goalHues.first;
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
          const Text(
            'New goal',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: _dec('Name', hint: 'Deep work'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _minutes,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _dec('Minutes'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final p in GoalPeriod.values) ...[
                if (p != GoalPeriod.values.first) const SizedBox(width: 8),
                _periodChip(p),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _periodHint(_period),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Sections',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Text(
                '$_sections',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accent,
                ),
              ),
            ],
          ),
          Slider(
            value: _sections.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: accent,
            onChanged: (v) => setState(() => _sections = v.round()),
          ),
          SegmentedBar(ratio: 0.62, sections: _sections, color: accent),
          const SizedBox(height: 6),
          Text(
            'Just visual — splits the bar so partial progress is easier to read.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: !_valid
                  ? null
                  : () => Navigator.pop(
                        context,
                        NewGoalResult(
                          name: _name.text.trim(),
                          targetMinutes: int.parse(_minutes.text),
                          period: _period,
                          sections: _sections,
                        ),
                      ),
              child: const Text(
                'Create goal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _periodHint(GoalPeriod p) => switch (p) {
        GoalPeriod.daily => 'Resets every midnight.',
        GoalPeriod.weekly => 'Resets every Monday.',
        GoalPeriod.biweekly => 'Resets every other Monday.',
        GoalPeriod.monthly => 'Resets on the 1st of each month.',
      };

  Widget _periodChip(GoalPeriod p) {
    final selected = _period == p;
    return InkWell(
      onTap: () => setState(() => _period = p),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? goalHues.first
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          p.chipLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );
}

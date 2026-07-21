import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/goal_type.dart';
import '../data/period.dart';
import 'format.dart';
import 'segmented_bar.dart';

class NewGoalResult {
  final String name;

  /// Minutes for time goals; number of check-ins for count goals.
  final int targetMinutes;
  final GoalPeriod period;
  final int sections;
  final GoalType type;

  const NewGoalResult({
    required this.name,
    required this.targetMinutes,
    required this.period,
    required this.sections,
    required this.type,
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
  final _times = TextEditingController(text: '3');
  GoalType _type = GoalType.time;
  GoalPeriod _period = GoalPeriod.weekly;
  int _sections = 1;

  @override
  void dispose() {
    _name.dispose();
    _minutes.dispose();
    _times.dispose();
    super.dispose();
  }

  bool get _isCount => _type == GoalType.count;

  int get _target => int.tryParse(_isCount ? _times.text : _minutes.text) ?? 0;

  bool get _valid => _name.text.trim().isNotEmpty && _target > 0;

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
            decoration: _dec('Name', hint: _isCount ? 'Gym' : 'Deep work'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _chip(
                'Time',
                selected: !_isCount,
                onTap: () => setState(() => _type = GoalType.time),
              ),
              const SizedBox(width: 8),
              _chip(
                'Check-ins',
                selected: _isCount,
                onTap: () => setState(() => _type = GoalType.count),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isCount
                ? 'Do it a number of times per period — one tap per check-in.'
                : 'Log minutes with timers or manual sessions.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 14),
          if (_isCount)
            TextField(
              controller: _times,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _dec('Times', hint: '3'),
              onChanged: (_) => setState(() {}),
            )
          else
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
          if (!_isCount) ...[
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
              'Just visual — splits the bar so partial progress is easier '
              'to read.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
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
                        targetMinutes: _target,
                        period: _period,
                        // A count goal's bar reads best with one segment
                        // per check-in.
                        sections: _isCount ? _target.clamp(1, 10) : _sections,
                        type: _type,
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

  Widget _periodChip(GoalPeriod p) => _chip(
    p.chipLabel,
    selected: _period == p,
    onTap: () => setState(() => _period = p),
  );

  Widget _chip(
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.black
                : Colors.white.withValues(alpha: 0.6),
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

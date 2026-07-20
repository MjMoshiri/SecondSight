import 'package:flutter/material.dart';

/// '2h 10m', '45m', '0m' — for logged totals and targets.
String fmtCompact(int ms) {
  final minutes = ms ~/ 60000;
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (h == 0) return '${m}m';
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}

/// '1:02:33' or '12:33' — for the live ticking timer.
String fmtTicking(int ms) {
  final s = ms ~/ 1000;
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  final mm = m.toString().padLeft(2, '0');
  final ss = sec.toString().padLeft(2, '0');
  return h > 0 ? '$h:$mm:$ss' : '$m:$ss';
}

const goalHues = [
  Color(0xFF5EEAD4), // teal
  Color(0xFFFBBF24), // amber
  Color(0xFFA78BFA), // violet
  Color(0xFFFB7185), // rose
  Color(0xFF7DD3FC), // sky
];

Color goalColor(String goalId) {
  var sum = 0;
  for (final c in goalId.codeUnits) {
    sum = (sum + c) & 0x7fffffff;
  }
  return goalHues[sum % goalHues.length];
}

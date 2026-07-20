# SecondSight

A small time-logging app for goals like "400 minutes of deep work weekly".

Create a goal, pick a cadence (daily, weekly, biweekly, or monthly — weeks
start on Monday), and hit play when you're working on it. Pause, resume,
stop — stopped time gets logged against the current period. The Report tab
shows how past periods went: hit rate, streaks, and a bar for every period
since the goal was created.

The home-screen widget is the main way to use it day to day: live ticking
timers, per-goal progress bars, and play/pause/stop buttons that work
without opening the app. A quiet notification keeps the running timer
visible in the shade.

## Stack

- Flutter (Dart), Android only for now
- drift (SQLite) for storage — three tables: goals, time logs, active timers
- home_widget + a native RemoteViews layout for the widget (Chronometer for
  the ticking, Flutter-rendered progress bars)
- flutter_local_notifications for the timer notification
- rxdart for the reactive streams that keep the app, widget, and
  notifications in sync

## Build

```sh
flutter pub get
flutter build apk --release --split-per-abi
```

Tests: `flutter test`

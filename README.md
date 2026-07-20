# SecondSight

A small time-logging app for tracking goals like "3 hours of exercise weekly" with a widget. (suprising there wasn't a good enough app for android for this simple ask!)


## Stack

- Flutter (Dart)
- drift (SQLite) 

## Build

```sh
flutter pub get
flutter build apk --release --split-per-abi
```

Tests: `flutter test`

# SecondSight

A small time-logging app for tracking goals like "3 hours of exercise weekly" with a widget. (suprising there wasn't a good enough app for android for this simple ask!)

Goals can also be plain check-ins — "gym 3 times a week" — one tap per time, no timer. Sessions and check-ins can be added or fixed by hand if you forgot to log.

## Stack

- Flutter (Dart)
- drift (SQLite) 

## Build

```sh
flutter pub get
flutter build apk --release --split-per-abi
```

Tests: `flutter test`

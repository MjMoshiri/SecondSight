# Overview

Second Sight is an Android application designed for tracking tasks and their respective entries. User can create/edit/delete tasks, add multiple entries to each task, and control entries by pausing, resuming, or stopping them.

## App Structure

The application uses the MVVM (Model-View-ViewModel) architecture and is built with Jetpack Compose. It uses Room for local database storage, Hilt for dependency injection, gradle for build automation, and Kotlin as the primary programming language.

### Data

This directory contains data classes (`Interval`, `Task`, `TaskEntry`, `TaskWithEntries`), repository definitions, and Data Access Objects (DAOs).

#### Data Classes Additional Info

`Interval` is helper class for storing time intervals between each pause/resume/stop action for each entry.

`TaskWithEntries` is a helper class for querying tasks and their entries from the database.


### Database

This directory contains `AppDB`, the application's Room database.

### DI

Dependency Injection is handled by the Hilt library in this directory. It contains definitions for singletons and other injected objects.

### UI

The UI is built with Jetpack Compose and contains screens and notifications-related files. The primary screens are:

1. `Task List`: Displays the list of tasks.
2. `Entry List`: Shows the entries for each task.
3. `Entry`: Allows users to manage each entry (pause, resume, stop).

### ViewModel

This directory contains ViewModel and ViewModel provider classes, handling the logic for the application.
It's good to mention that the Receiver (related to notifications) uses a ViewModel to handle the notification actions.

### Util

This directory contains utility functions and files used across the app (e.g. TypeConverters).

## App Flow

1. The main screen is the `Task List` screen, controlled by `TaskListViewModel` and `TaskRepository`. Users can create, edit, or delete tasks here.

2. Clicking on a task takes the user to the `Entry List` screen for that task. This screen is controlled by `EntryListViewModel` and `EntryRepository`. Here, users can create or delete entries and monitor the progress of each entry.

3. By creating a new entry or clicking on an existing one, users navigate to the `Entry` screen. Here, they can manage the entry by pausing, resuming, or stopping it. A corresponding notification is also created for each entry.

## Permissions

The application requires notification permissions, which are requested from the user as needed (API level 33).

## Libraries

The application use gradle for build automation and dependency management. you can find the list of dependencies in the `build.gradle` file. but here is a list of the most important ones :

- Room for local data storage
- Hilt for dependency injection
- Additional Google Material Icons
- KSP/KAPT for annotation processing

The application operates offline and does not make any network requests.

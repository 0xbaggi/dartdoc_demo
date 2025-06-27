# DartDoc Demo - Task Manager App

A Flutter application that demonstrates the use of dartdoc for code documentation. This project showcases a simple task management application with different task types.

## Project Overview

This Task Manager application allows users to:

- Create and manage different types of tasks (Regular, Work, and Personal)
- Set priorities and completion status
- Add specific details to different task types

## Documentation Guidelines Used

This project follows the [dartdoc](https://dart.dev/tools/dartdoc) guidelines to generate API documentation:

## Generating Documentation

To generate the API documentation for this project:

```bash
# Install dartdoc if you haven't already
dart pub global activate dartdoc

# Run dartdoc in the project directory
dart pub global run dartdoc

# Or if you have dartdoc in your PATH
dartdoc
```

The generated documentation will be available in the `doc/api` directory.

## Project Structure

- `lib/models/` - Contains the task data models
  - `task.dart` - Base Task class
  - `task_types.dart` - Specialized task types (WorkTask, PersonalTask)
- `lib/services/` - Contains business logic
  - `task_manager.dart` - Service for managing tasks
- `lib/main.dart` - Entry point and UI components

Made by Baggi [GitHub](https://github.com/0xbaggi)
import 'task.dart';

/// A work-related task with additional business properties.
///
/// [WorkTask] extends the base [Task] class to include work-specific
/// properties like [project] and [deadline]. This allows for better
/// organization and tracking of work-related tasks.
///
/// Example:
/// ```dart
/// var workTask = WorkTask(
///   id: 1,
///   title: 'Complete project proposal',
///   project: 'Client X Website',
///   deadline: DateTime(2025, 7, 15),
///   priority: 3,
/// );
/// ```
class WorkTask extends Task {
  /// The project this task belongs to
  String project;

  /// The deadline for this task
  DateTime? deadline;

  /// Creates a new work task.
  ///
  /// Extends the base [Task] class constructor and adds:
  /// - [project]: The name of the project this task belongs to
  /// - [deadline]: Optional deadline date for the task
  WorkTask({
    required super.id,
    required super.title,
    super.isCompleted = false,
    super.priority = 1,
    required this.project,
    this.deadline,
  });

  /// Checks if the task is overdue based on its deadline.
  ///
  /// Returns `true` if the task has a deadline in the past and
  /// is not yet completed. Returns `false` if the task is completed
  /// or has no deadline or the deadline is in the future.
  bool isOverdue() {
    if (deadline == null) return false;
    return deadline!.isBefore(DateTime.now()) && !isCompleted;
  }

  @override
  String toString() => 'WorkTask{id: $id, title: $title, completed: $isCompleted, '
      'priority: $priority, project: $project, deadline: $deadline}';
}

/// A personal task with additional personal properties.
class PersonalTask extends Task {
  /// The location where this task needs to be done
  String? location;

  /// The category of the personal task
  String category;

  /// Constructor for creating a new personal task
  PersonalTask({
    required super.id,
    required super.title,
    super.isCompleted = false,
    super.priority = 1,
    this.location,
    this.category = 'General',
  });

  @override
  String toString() => 'PersonalTask{id: $id, title: $title, completed: $isCompleted, '
      'priority: $priority, location: $location, category: $category}';
}

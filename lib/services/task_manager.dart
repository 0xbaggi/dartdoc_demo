import '../models/task.dart';
import '../models/task_types.dart';

/// A service class that manages all tasks in the application.
///
/// [TaskManager] provides methods to add, update, delete and retrieve tasks.
/// It maintains an internal list of tasks and handles operations on them,
/// while preserving proper encapsulation.
///
/// This class acts as the main interface for interacting with tasks in the system.
class TaskManager {
  /// Internal list of tasks
  final List<Task> _tasks = [];

  /// Current ID counter for new tasks
  int _currentId = 1;

  /// Returns an unmodifiable list of all tasks.
  ///
  /// The returned list is a copy to maintain encapsulation.
  /// Changes to the returned list will not affect the internal tasks.
  List<Task> get allTasks => List.unmodifiable(_tasks);

  /// Returns a list of completed tasks.
  ///
  /// This getter filters the internal task list and returns only
  /// tasks that have their [isCompleted] property set to true.
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  /// Returns a list of incomplete tasks.
  ///
  /// This getter filters the internal task list and returns only
  /// tasks that have their [isCompleted] property set to false.
  List<Task> get incompleteTasks => _tasks.where((task) => !task.isCompleted).toList();

  /// Returns a list of work tasks.
  ///
  /// This getter filters the internal task list and returns only
  /// tasks that are instances of [WorkTask].
  List<WorkTask> get workTasks => _tasks.whereType<WorkTask>().toList();

  /// Returns a list of personal tasks.
  ///
  /// This getter filters the internal task list and returns only
  /// tasks that are instances of [PersonalTask].
  List<PersonalTask> get personalTasks => _tasks.whereType<PersonalTask>().toList();

  /// Adds a new regular task to the task list.
  ///
  /// Takes a required [title] string and an optional [priority] integer.
  /// Returns the newly created [Task] object.
  ///
  /// Example:
  /// ```dart
  /// var newTask = taskManager.addTask('Buy groceries', priority: 2);
  /// ```
  Task addTask(String title, {int priority = 1}) {
    final task = Task(
      id: _currentId++,
      title: title,
      priority: priority,
    );
    _tasks.add(task);
    return task;
  }

  /// Adds a new work task to the task list.
  ///
  /// Takes a required [title] string, a required [project] string,
  /// and optional [deadline] and [priority] parameters.
  /// Returns the newly created [WorkTask] object.
  ///
  /// Example:
  /// ```dart
  /// var workTask = taskManager.addWorkTask(
  ///   'Finish report',
  ///   'Annual Project',
  ///   deadline: DateTime(2025, 7, 1),
  ///   priority: 3,
  /// );
  /// ```
  WorkTask addWorkTask(String title, String project, {DateTime? deadline, int priority = 1}) {
    final task = WorkTask(
      id: _currentId++,
      title: title,
      project: project,
      deadline: deadline,
      priority: priority,
    );
    _tasks.add(task);
    return task;
  }

  /// Adds a new personal task to the task list.
  ///
  /// Takes a required [title] string, a required [category] string,
  /// and optional [location] and [priority] parameters.
  /// Returns the newly created [PersonalTask] object.
  ///
  /// Example:
  /// ```dart
  /// var personalTask = taskManager.addPersonalTask(
  ///   'Buy groceries',
  ///   'Shopping',
  ///   location: 'Supermarket',
  /// );
  /// ```
  PersonalTask addPersonalTask(String title, String category, {String? location, int priority = 1}) {
    final task = PersonalTask(
      id: _currentId++,
      title: title,
      category: category,
      location: location,
      priority: priority,
    );
    _tasks.add(task);
    return task;
  }

  /// Updates an existing task with new values.
  ///
  /// Takes the [id] of the task to update and optional parameters
  /// for the properties to update. Returns `true` if the task was found
  /// and updated, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// bool success = taskManager.updateTask(1, title: 'Updated title', priority: 3);
  /// ```
  bool updateTask(int id, {String? title, bool? isCompleted, int? priority}) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return false;

    if (title != null) _tasks[index].title = title;
    if (isCompleted != null) _tasks[index].isCompleted = isCompleted;
    if (priority != null) _tasks[index].priority = priority;

    return true;
  }

  /// Deletes a task by its ID.
  ///
  /// Takes the [id] of the task to delete. Returns `true` if the task was found
  /// and deleted, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// bool deleted = taskManager.deleteTask(1);
  /// ```
  bool deleteTask(int id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    return _tasks.length < initialLength;
  }

  Task? getTaskById(int id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get tasks sorted by priority (highest first)
  List<Task> getTasksByPriority() {
    final sortedTasks = List<Task>.from(_tasks);
    sortedTasks.sort((a, b) => b.priority.compareTo(a.priority));
    return sortedTasks;
  }
}

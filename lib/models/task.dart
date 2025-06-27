/// A base class representing a task
class Task {
  /// Unique identifier for the task
  final int id;

  /// The title of the task
  String title;

  /// Flag indicating if the task is completed
  bool isCompleted;

  /// Priority level of the task
  int priority;

  /// Constructor for creating a new task
  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = 1,
  });

  /// Mark the task as completed
  void complete() {
    isCompleted = true;
  }

  /// Mark the task as incomplete
  void uncomplete() {
    isCompleted = false;
  }

  /// Toggle the completion status
  void toggleCompletion() {
    isCompleted = !isCompleted;
  }

  /// Create a copy of this task with optional new values
  Task copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    int? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }

  @override
  String toString() => 'Task{id: $id, title: $title, completed: $isCompleted, priority: $priority}';
}


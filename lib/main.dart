import 'package:flutter/material.dart';
import 'models/task_types.dart';
import 'services/task_manager.dart';

/// Entry point for the Task Manager application.
///
/// Initializes and runs the Flutter application.
void main() {
  runApp(const MyApp());
}

/// The root widget of the Task Manager application.
///
/// Creates the MaterialApp with appropriate theme and home page.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TaskManagerHomePage(title: 'Task Manager'),
    );
  }
}

/// The home page of the Task Manager application.
///
/// This is a stateful widget that displays the task input form and the list of tasks.
class TaskManagerHomePage extends StatefulWidget {
  /// Creates a [TaskManagerHomePage].
  ///
  /// Requires a [title] to display in the app bar.
  const TaskManagerHomePage({super.key, required this.title});

  /// The title displayed in the app bar.
  final String title;

  @override
  State<TaskManagerHomePage> createState() => _TaskManagerHomePageState();
}

/// The state for the [TaskManagerHomePage] widget.
///
/// Manages the task list and user interaction with tasks.
class _TaskManagerHomePageState extends State<TaskManagerHomePage> {
  /// The service that manages all tasks.
  final TaskManager _taskManager = TaskManager();

  /// Controller for the task title input field.
  final TextEditingController _taskController = TextEditingController();

  /// The currently selected task type.
  String _currentTaskType = 'Regular';

  /// Controller for the project field (used for WorkTask).
  final TextEditingController _projectController = TextEditingController();

  /// Controller for the category field (used for PersonalTask).
  final TextEditingController _categoryController = TextEditingController();

  /// Controller for the location field (used for PersonalTask).
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add some example tasks
    _taskManager.addTask('Buy groceries', priority: 2);
    _taskManager.addWorkTask('Complete project', 'Flutter App', priority: 3);
    _taskManager.addPersonalTask('Go to gym', 'Health', location: 'Fitness Center');
  }

  @override
  void dispose() {
    _taskController.dispose();
    _projectController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Adds a new task based on the currently selected task type.
  ///
  /// Uses the values from the input fields to create the appropriate
  /// task type and adds it to the [TaskManager].
  void _addTask() {
    if (_taskController.text.isEmpty) return;

    setState(() {
      switch (_currentTaskType) {
        case 'Work':
          if (_projectController.text.isNotEmpty) {
            _taskManager.addWorkTask(
              _taskController.text,
              _projectController.text,
            );
          }
          break;
        case 'Personal':
          _taskManager.addPersonalTask(
            _taskController.text,
            _categoryController.text.isEmpty ? 'General' : _categoryController.text,
            location: _locationController.text.isEmpty ? null : _locationController.text,
          );
          break;
        default: // Regular task
          _taskManager.addTask(_taskController.text);
      }

      // Clear input fields
      _taskController.clear();
      _projectController.clear();
      _categoryController.clear();
      _locationController.clear();
    });
  }

  /// Toggles the completion status of a task.
  ///
  /// Takes the [taskId] of the task whose completion status
  /// should be toggled.
  void _toggleTaskCompletion(int taskId) {
    setState(() {
      final task = _taskManager.getTaskById(taskId);
      if (task != null) {
        task.toggleCompletion();
      }
    });
  }

  /// Deletes a task from the task list.
  ///
  /// Takes the [taskId] of the task to delete.
  void _deleteTask(int taskId) {
    setState(() {
      _taskManager.deleteTask(taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                // Task type selector
                DropdownButton<String>(
                  value: _currentTaskType,
                  items: ['Regular', 'Work', 'Personal'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _currentTaskType = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),

                // Common task title field
                TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Task title',
                  ),
                ),
                const SizedBox(height: 8),

                // Conditional fields based on task type
                if (_currentTaskType == 'Work') ...[
                  TextField(
                    controller: _projectController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Project name',
                    ),
                  ),
                ] else if (_currentTaskType == 'Personal') ...[
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Category',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location (optional)',
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),

          const Divider(),

          // Task list
          Expanded(
            child: ListView.builder(
              itemCount: _taskManager.allTasks.length,
              itemBuilder: (context, index) {
                final task = _taskManager.allTasks[index];

                // Determine task icon based on task type
                IconData taskIcon;
                Color taskColor;

                if (task is WorkTask) {
                  taskIcon = Icons.work;
                  taskColor = Colors.blue;
                } else if (task is PersonalTask) {
                  taskIcon = Icons.person;
                  taskColor = Colors.green;
                } else {
                  taskIcon = Icons.check_circle;
                  taskColor = Colors.orange;
                }

                // Format additional task info
                String subtitleText = '';

                if (task is WorkTask) {
                  subtitleText = 'Project: ${task.project}';
                  if (task.deadline != null) {
                    subtitleText += ' | Due: ${task.deadline!.toString().substring(0, 10)}';
                  }
                  if (task.isOverdue()) {
                    subtitleText += ' (OVERDUE)';
                  }
                } else if (task is PersonalTask) {
                  subtitleText = 'Category: ${task.category}';
                  if (task.location != null && task.location!.isNotEmpty) {
                    subtitleText += ' | Location: ${task.location}';
                  }
                }

                return ListTile(
                  leading: Icon(taskIcon, color: taskColor),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(subtitleText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Priority indicator
                      Container(
                        padding: const EdgeInsets.all(4),
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: task.priority > 2 ? Colors.red :
                                 task.priority > 1 ? Colors.orange :
                                 Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          task.priority.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Complete/incomplete toggle
                      IconButton(
                        icon: Icon(
                          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                        ),
                        onPressed: () => _toggleTaskCompletion(task.id),
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

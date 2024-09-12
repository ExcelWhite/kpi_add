import 'package:code_base/backend/task_service.dart';
import 'package:code_base/models/task.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  Map<int, List<Task>> _tasksByFolder = {};
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  Map<int, List<Task>> get tasksByFolder => _tasksByFolder;
  bool get isLoading => _isLoading;

  // Fetch tasks from the server and classify them by parentId (folder)
  Future<void> fetchTasks() async {
    _setLoading(true);
    try {
      final fetchedTasks = await _taskService.fetchTask();
      _tasks = fetchedTasks;

      // Classify tasks by their parentId (folders)
      _tasksByFolder = classifyTasksByFolder(_tasks);
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Helper function to classify tasks by folder (parentId)
  Map<int, List<Task>> classifyTasksByFolder(List<Task> tasks) {
    Map<int, List<Task>> tasksByFolder = {};

    for (Task task in tasks) {
      tasksByFolder.putIfAbsent(task.parentId, () => []);
      tasksByFolder[task.parentId]!.add(task);
    }

    return tasksByFolder;
  }

  // Private method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
  }

  void reorderTasksInSameFolder(int parentId, int oldIndex, int newIndex) {
    final tasks = tasksByFolder[parentId];

    // Adjust the order within the same folder
    final movedTask = tasks!.removeAt(oldIndex);
    tasks.insert(newIndex, movedTask);

    // Update the order for all tasks in the folder
    for (int i = 0; i < tasks.length; i++) {
      tasks[i] = tasks[i].copyWith(order: i + 1); // Ensure order starts from 1
    }

    // Update the tasks list
    _tasks = _tasksByFolder.values.fold<List<Task>>([], (list, tasks) => list..addAll(tasks));

    tasksByFolder[parentId] = tasks;
    notifyListeners(); // Update the UI via provider
  }

  void moveTaskToAnotherFolder(int oldParentId, int newParentId, int oldIndex, int newIndex) {
    // Remove the task from the old folder
    final task = tasksByFolder[oldParentId]!.removeAt(oldIndex);

    // Update the order of tasks in the old folder
    for (int i = 0; i < tasksByFolder[oldParentId]!.length; i++) {
      tasksByFolder[oldParentId]![i] = tasksByFolder[oldParentId]![i].copyWith(order: i + 1);
    }

    // Insert the task into the new folder and update its parentId
    final newTask = task.copyWith(parentId: newParentId, order: newIndex + 1);
    tasksByFolder.putIfAbsent(newParentId, () => []);
    tasksByFolder[newParentId]!.insert(newIndex, newTask);

    // Update the order of tasks in the new folder
    for (int i = 0; i < tasksByFolder[newParentId]!.length; i++) {
      tasksByFolder[newParentId]![i] = tasksByFolder[newParentId]![i].copyWith(order: i + 1);
      // Update the order in the service
      // _taskService.updateTask(tasksByFolder[newParentId]![i].indicatorToMoId, newParentId, i + 1);
    }

    // Update the tasks list
    _tasks = _tasksByFolder.values.fold<List<Task>>([], (list, tasks) => list..addAll(tasks));

    notifyListeners(); // Update the UI via provider
  }

  Future<void> saveTaskListInstance(List<Task> taskList) async {
    await _taskService.saveTaskListInstance(taskList);
  }



}

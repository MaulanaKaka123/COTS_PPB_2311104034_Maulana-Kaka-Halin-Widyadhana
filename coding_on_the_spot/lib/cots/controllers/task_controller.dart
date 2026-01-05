import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isDone).length;

  List<Task> get recentTasks {
    final sorted = List<Task>.from(_tasks)
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    return sorted.take(3).toList();
  }

  // Fetch all tasks from API
  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _taskService.getAllTasks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter tasks locally
  List<Task> filterTasks(String filter) {
    if (filter == 'Semua') return _tasks;
    return _tasks.where((t) => t.status.toUpperCase() == filter.toUpperCase()).toList();
  }

  // Search tasks locally
  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    return _tasks.where((t) =>
        t.title.toLowerCase().contains(query.toLowerCase()) ||
        t.course.toLowerCase().contains(query.toLowerCase())).toList();
  }

  // Add new task via API
  Future<bool> addTask(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTask = await _taskService.addTask(task);
      _tasks.add(newTask);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Toggle task completion via API
  Future<bool> toggleTaskStatus(int taskId) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    final task = _tasks[index];
    final newIsDone = !task.isDone;

    try {
      final updatedTask = await _taskService.toggleTaskCompletion(taskId, newIsDone);
      _tasks[index] = updatedTask;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update task via API
  Future<bool> updateTask(int taskId, Map<String, dynamic> updates) async {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return false;

    try {
      final updatedTask = await _taskService.updateTask(taskId, updates);
      _tasks[index] = updatedTask;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

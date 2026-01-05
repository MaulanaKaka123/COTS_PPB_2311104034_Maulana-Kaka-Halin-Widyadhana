import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task.dart';

class TaskService {
  final String _baseUrl = ApiConfig.baseUrl;
  final String _endpoint = ApiConfig.tasksEndpoint;

  // GET all tasks
  Future<List<Task>> getAllTasks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_endpoint?select=*'),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  // GET tasks by status
  Future<List<Task>> getTasksByStatus(String status) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$_endpoint?select=*&status=eq.$status'),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  // POST add new task
  Future<Task> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endpoint'),
      headers: ApiConfig.headers,
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return Task.fromJson(data.first);
    } else {
      throw Exception('Failed to add task: ${response.statusCode}');
    }
  }

  // PATCH update task
  Future<Task> updateTask(int id, Map<String, dynamic> updates) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl$_endpoint?id=eq.$id'),
      headers: ApiConfig.headers,
      body: json.encode(updates),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return Task.fromJson(data.first);
    } else {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  }

  // Toggle task completion
  Future<Task> toggleTaskCompletion(int id, bool isDone) async {
    return updateTask(id, {
      'is_done': isDone,
      'status': isDone ? 'SELESAI' : 'BERJALAN',
    });
  }

  // Update note
  Future<Task> updateNote(int id, String note) async {
    return updateTask(id, {'note': note});
  }
}

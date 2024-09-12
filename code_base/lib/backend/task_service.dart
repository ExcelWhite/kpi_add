import 'dart:convert';
import 'package:code_base/models/task.dart';
import 'package:http/http.dart' as http;

class TaskService {
  String getTaskUrl = "https://development.kpi-drive.ru/_api/indicators/get_mo_indicators";
  String updateTaskUrl = "https://development.kpi-drive.ru/_api/indicators/save_indicator_instance_field";
  String token = "48ab34464a5573519725deb5865cc74c";

  Future<List<Task>> fetchTask() async {
    //endpoint url and bearer token
    final url = Uri.parse(getTaskUrl);
    //form-data (body)
    final Map<String, String> requestBody = {
      'period_start': '2024-06-01',
      'period_end': '2024-06-30',
      'period_key': 'month',
      'requested_mo_id': '478',
      'behaviour_key': 'task,kpi_task',
      'with_result': 'false',
      'response_fields': 'name,indicator_to_mo_id,parent_id,order',
      'auth_user_id': '2',
    };

    try{
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );

      //on successful request
      if(response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = jsonDecode(responseBody);
        final List<dynamic> rows = jsonData['DATA']['rows'] ?? [];

        // Map rows to a list of Task objects
        return rows.map((task) => Task.fromMap(task)).toList();
      } else {
        print('Failed to fetch tasks');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (exception) {
      print('Error: $exception');
      return [];
    }
  }

  Future<void> saveTaskListInstance(List<Task> taskList) async {
    final url = Uri.parse(updateTaskUrl);

    for (var task in taskList) {
      // Prepare request body for each task in the list
      final requestBody = {
        'period_start': '2024-06-01',
        'period_end': '2024-06-30',
        'period_key': 'month',
        'indicator_to_mo_id': task.indicatorToMoId.toString(),
        'field_name[]': ['parent_id', 'order'],
        'field_value[]': [task.parentId.toString(), task.order.toString()],
        'auth_user_id': '2',
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: requestBody,
        );

        if (response.statusCode != 200) {
          final decodedBody = utf8.decode(response.bodyBytes);
          print('Failed to update task: ${task.indicatorToMoId}');
          print('Response body: $decodedBody');
        } else {
          print('Task updated successfully: ${task.indicatorToMoId}');
        }
      } catch (exception) {
        print('Error updating task ${task.indicatorToMoId}: $exception');
      }
    }
  }


}
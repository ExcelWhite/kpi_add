import 'package:code_base/screens/kanban_board_screen.dart';
import 'package:code_base/state_management/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kanban Test',
        home: KanbanBoardScreen(),
      ),
    );
  }
}

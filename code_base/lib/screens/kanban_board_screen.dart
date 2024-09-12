import 'package:code_base/constants.dart';
import 'package:code_base/state_management/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';
import 'package:provider/provider.dart';

class KanbanBoardScreen extends StatefulWidget {
  @override
  _KanbanBoardScreenState createState() => _KanbanBoardScreenState();
}

class _KanbanBoardScreenState extends State<KanbanBoardScreen> {
  final BoardViewController _kanbanBoardController = BoardViewController();
  final AppColors _appColors = AppColors();

  @override
  void initState() {
    super.initState();    
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskProvider.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: _appColors.backgroundColor,
          ),
        ),
        title: Center(
          child: Text(
            'Доска Задач',
            style: TextStyle(color: _appColors.textColor, fontWeight: FontWeight.bold),
          )
        ),
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                color: _appColors.backgroundColor,
              ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async{
                          await taskProvider.saveTaskListInstance(taskProvider.tasks);
                          ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Изменения сохранены', style: TextStyle(color: _appColors.textSecondaryColor)),
                            backgroundColor: _appColors.approvedColor,
                          ),
                        );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: deviceWidth*0.6,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _appColors.secondaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'сохранить изменения',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: _appColors.textColor
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: deviceWidth,
                    height: deviceHeight - 100,
                    decoration: BoxDecoration(
                      color: _appColors.backgroundColor,
                    ),
                    child: BoardView(
                      boardViewController: _kanbanBoardController,
                      width: deviceWidth *0.5,
                      bottomPadding: 20.0,
                      lists: taskProvider.tasksByFolder.entries.map((entry) {
                        final parentId = entry.key;
                        final tasks = entry.value;
                    
                        return BoardList(
                          key: ValueKey(parentId),
                          backgroundColor: _appColors.primaryColor.withOpacity(0.5),
                          header: [
                            Text(
                              getFolderName(parentId, taskProvider),
                              style: TextStyle(fontSize: 18, color: _appColors.textColor, fontWeight: FontWeight.bold),
                              ),
                          ],
                          items: tasks.map((task) => BoardItem(
                            key: ValueKey(task.indicatorToMoId),
                            item: Card(
                              color: _appColors.cardColor.withOpacity(0.7),
                              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: ListTile(
                                title: Text(task.name, style: TextStyle(color: _appColors.textSecondaryColor),),
                                subtitle: Text('Order: ${task.order}', style: TextStyle(color: _appColors.textSecondaryColor),),
                              ),
                            ),
                            onDropItem: (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
                              final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                    
                              // Check if task is being moved to its own folder
                              final taskBeingMoved = taskProvider.tasksByFolder.values.elementAt(oldListIndex!)[oldItemIndex!];
                              final newParentId = taskProvider.tasksByFolder.keys.elementAt(listIndex!);
                    
                              if (taskBeingMoved.indicatorToMoId == newParentId) {
                                // Prevent moving a task into its own folder
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Не удается переместить задачу в ее собственную папку!", style: TextStyle(color: _appColors.textColor),),
                                    backgroundColor: _appColors.secondaryColor,
                                    ),
                                );
                    
                                taskProvider.fetchTasks();
                                return;
                              }
                    
                              // If the move is valid, apply the reordering logic
                              if (oldListIndex == listIndex) {
                                // Reordering in the same list (parent folder)
                                taskProvider.reorderTasksInSameFolder(
                                  taskProvider.tasksByFolder.keys.elementAt(listIndex), 
                                  oldItemIndex, 
                                  itemIndex!,
                                );
                              } else {
                                // Task moved to a different list (different parent folder)
                                taskProvider.moveTaskToAnotherFolder(
                                  taskProvider.tasksByFolder.keys.elementAt(oldListIndex), // Old parentId
                                  taskProvider.tasksByFolder.keys.elementAt(listIndex),    // New parentId
                                  oldItemIndex,
                                  itemIndex!,
                                );
                              }
                            },
                    
                          )).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
  String getFolderName(int parentId, TaskProvider taskProvider){
    for (var entry in taskProvider.tasksByFolder.entries) {
      for (var task in entry.value) {
        if (task.indicatorToMoId == parentId) {
          return task.name;
        }
      }
    }
    return 'корень';
  }
}

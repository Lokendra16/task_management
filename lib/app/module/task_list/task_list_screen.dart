import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/app/module/add_task/add_task_screen.dart';
import 'package:task_management/app/services/task_model.dart';
import 'package:task_management/app/utils/app_tags.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskModel> taskList = [];
  ValueNotifier<bool> updateTaskList = ValueNotifier(false);

  @override
  void initState() {
    fetchTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(AppTags.taskList, style: TextStyle()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (taskList.isNotEmpty) ...[
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ValueListenableBuilder(
                      valueListenable: updateTaskList,
                      builder: (context, value, child) {
                        return ListView.builder(
                            itemCount: taskList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Task Name : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            taskList[index].name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Due Date : ",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              taskList[index].dueDate ?? "NA",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                    Row(
                                      children: [
                                        const Text(
                                          "Priority : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            taskList[index].priority,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      })),
            )
          ] else ...[
            const Expanded(child: Center(child: Text("No Task Found!")))
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          if (result) {
            fetchTaskList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchTaskList() async {
    taskList.clear();
    final box = Hive.box<TaskModel>('tasks');
    taskList = box.values.toList();
    updateTaskList.value = !updateTaskList.value;
  }
}

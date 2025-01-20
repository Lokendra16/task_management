import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_management/app/services/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  DateTime? dueDate;
  String formattedDate = "";
  String priority = 'Medium';

  ValueNotifier<bool> updateDropDown = ValueNotifier(false);
  ValueNotifier<bool> updateDueDate = ValueNotifier(false);

  Future<void> submit() async {
    final task = TaskModel(
      name: nameController.text,
      dueDate: formattedDate,
      priority: priority,
    );

    final box = Hive.box<TaskModel>('tasks');
    await box.add(task);

    if (mounted) {
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully!')),
      );
    }
    nameController.clear();
    dueDate = null;
    priority = 'Medium';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task", style: TextStyle()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Task Name',
                  contentPadding: EdgeInsets.zero,
                  isDense: true),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: updateDueDate,
              builder: (context, value, child) {
                return TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      debugPrint(formattedDate);
                      dueDate = pickedDate;
                      updateDueDate.value = !updateDueDate.value;
                    }
                  },
                  child: Text(
                    dueDate == null ? 'Select Due Date' : formattedDate,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }),
          ValueListenableBuilder(
              valueListenable: updateDropDown,
              builder: (context, value, child) {
                return DropdownButton<String>(
                  value: priority,
                  onChanged: (String? newValue) {
                    priority = newValue!;
                    updateDropDown.value = !updateDropDown.value;
                  },
                  items: <String>['High', 'Medium', 'Low']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              }),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await submit();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Enter Task Name')),
                );
              }
            },
            child: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}

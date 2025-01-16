import 'package:flutter/cupertino.dart';
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

  void _submit() {
    if (formKey.currentState!.validate()) {
      final task = TaskModel(
        name: nameController.text,
        dueDate: formattedDate,
        priority: priority,
      );

      final box = Hive.box<TaskModel>('tasks');
      box.add(task);

      Navigator.pop(context,true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task added successfully!')),
      );

      // Clear the form fields after submission
      nameController.clear();
      dueDate = null;
      priority = 'Medium';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task", style: TextStyle()),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Task Name',
                    contentPadding: EdgeInsets.zero,
                    isDense: true),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a task name' : null,
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
                      style: TextStyle(color: Colors.black),
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
              onPressed: _submit,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

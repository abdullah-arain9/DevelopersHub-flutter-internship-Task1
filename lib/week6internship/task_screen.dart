import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';

class TaskScreen extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Tasks")),
      body: Column(
        children: [
          TextField(controller: controller),
          ElevatedButton(
              onPressed: () {
                taskProvider.addTask(controller.text);
                controller.clear();
              },
              child: Text("Add Task")),
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(taskProvider.tasks[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      taskProvider.removeTask(index);
                    },
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          TextEditingController editController =
                          TextEditingController(
                              text: taskProvider.tasks[index]);
                          return AlertDialog(
                            title: Text("Edit Task"),
                            content: TextField(controller: editController),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    taskProvider.updateTask(
                                        index, editController.text);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Update"))
                            ],
                          );
                        });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
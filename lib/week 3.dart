import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const Week3App());
}

class Week3App extends StatelessWidget {
  const Week3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskManagerScreen(),
    );
  }
}

/* ---------------- MAIN SCREEN ---------------- */

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  List<String> tasks = [];
  List<bool> completed = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  /* -------- LOAD DATA -------- */
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
      completed = prefs
          .getStringList('completed')
          ?.map((e) => e == 'true')
          .toList() ??
          List.generate(tasks.length, (_) => false);
    });
  }

  /* -------- SAVE DATA -------- */
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
    await prefs.setStringList(
        'completed', completed.map((e) => e.toString()).toList());
  }

  /* -------- ADD TASK -------- */
  void addTask(String task) {
    setState(() {
      tasks.add(task);
      completed.add(false);
    });
    saveTasks();
  }

  /* -------- UPDATE TASK -------- */
  void updateTask(int index, String newTask) {
    setState(() {
      tasks[index] = newTask;
    });
    saveTasks();
  }

  /* -------- DELETE TASK -------- */
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      completed.removeAt(index);
    });
    saveTasks();
  }

  /* -------- TOGGLE COMPLETE -------- */
  void toggleComplete(int index) {
    setState(() {
      completed[index] = !completed[index];
    });
    saveTasks();
  }

  /* -------- ADD DIALOG -------- */
  void showAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter task name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                addTask(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  /* -------- EDIT DIALOG -------- */
  void showEditDialog(int index) {
    final controller = TextEditingController(text: tasks[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Update task",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                updateTask(index, controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
        backgroundColor: const Color(0xFF1D2671),
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          "No tasks added yet 👀",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 7,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  completed[index]
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color:
                  completed[index] ? Colors.green : Colors.grey,
                ),
                onPressed: () => toggleComplete(index),
              ),
              title: Text(
                tasks[index],
                style: TextStyle(
                  fontSize: 16,
                  decoration: completed[index]
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text(
                completed[index] ? "Completed" : "Pending",
                style: TextStyle(
                  color: completed[index]
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showEditDialog(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteTask(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1D2671),
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
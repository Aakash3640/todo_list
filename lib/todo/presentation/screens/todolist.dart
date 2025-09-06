import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/todo/presentation/widgets/taskcard.dart';
import '../../provider/itemProvider.dart';

class Todolist extends ConsumerWidget {
  final TextEditingController taskcontroller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themechange); // keep only theme here

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 9,
        backgroundColor: Colors.teal,
        title: const Text(
          "My Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(theme ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themechange.notifier).state = !theme;
            },
          ),
        ],
      ),

      body: Consumer(
        builder: (context, ref, child) {
          final items = ref.watch(itemProvider); // moved here

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.checklist, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "No tasks yet!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final task = items[index];
              return TaskCard(
                index: index,
                task: task,
                ref: ref,
                onEdit: () {
                  showDialogBox(
                    context,
                    ref,
                    index: index,
                    currentTitle: task.title,
                  );
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Task", style: TextStyle(color: Colors.white)),
        onPressed: () {
          showDialogBox(context, ref);
        },
      ),
    );
  }

  Future showDialogBox(
    BuildContext context,
    WidgetRef ref, {
    int? index,
    String? currentTitle,
  }) {
    taskcontroller.text = currentTitle ?? "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  index == null ? "Add Task" : "Update Task",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: taskcontroller,
                  decoration: InputDecoration(
                    hintText: "Enter your task here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final text = taskcontroller.text.trim();
                    if (text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Task cannot be empty")),
                      );
                      return;
                    }

                    final itemprovider = ref.read(itemProvider.notifier);
                    if (index == null) {
                      itemprovider.addItem(text);
                    } else {
                      itemprovider.editItem(index, text);
                    }
                    taskcontroller.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    index == null ? "Add Task" : "Update Task",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

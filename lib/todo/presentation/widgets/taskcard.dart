  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/item.dart';
import '../../provider/itemProvider.dart';

class TaskCard extends StatelessWidget {
  final int index;
  final Item task;
  final WidgetRef ref;
  final VoidCallback onEdit; // callback for edit

  const TaskCard({
    Key? key,
    required this.index,
    required this.task,
    required this.ref,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("TaskCard $index rebuild");

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            "${index + 1}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                ref.read(itemProvider.notifier).removeItem(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}

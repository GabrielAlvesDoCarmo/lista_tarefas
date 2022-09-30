import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({Key? key, required this.todo,required this.onDelete}) : super(key: key);
  final ToDo todo;
  final Function(ToDo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable.builder(
        actionPane: const SlidableStrechActionPane(),
        secondaryActionDelegate: SlideActionListDelegate(
            actions: [
              IconSlideAction(
                color: Colors.red,
                icon: Icons.delete,
                caption: "Deletar",
                onTap: (){
                  onDelete(todo);
                },
              ),
            ]
        ),
        actionExtentRatio: 0.20,
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd/MM/yyyy - HH:mm:ss').format(todo.date),
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              todo.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

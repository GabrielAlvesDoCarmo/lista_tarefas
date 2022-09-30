import 'package:flutter/material.dart';
import 'package:lista_tarefas/model/todo.dart';
import 'package:lista_tarefas/repositories/todo_repository.dart';

import '../widget/to_list_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<ToDo> todos = [];
  final TextEditingController todosController = TextEditingController();
  final ToDoRepository toDoRepository = ToDoRepository();
  ToDo? deletedTodo;
  int? deletedPosition;
  String? errorText;

  @override
  void initState() {
    super.initState();
    toDoRepository.getAllTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        controller: todosController,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          border: const OutlineInputBorder(),
                          labelText: "Adicione uma tarefa",
                          hintText: "Ex. Estudo flutter",
                          errorText: errorText,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: onPressButton,
                      child: const Text(
                        "+",
                        style: TextStyle(fontSize: 30),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (var todo in todos.reversed)
                        ToDoListItem(todo: todo, onDelete: onDelete),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text("Voce possui ${todos.length} tarefas"),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: removeAll,
                      style: ElevatedButton.styleFrom(
                          primary: Colors.black, padding: EdgeInsets.all(14)),
                      child: const Text("Limpar tudo"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressButton() {
    var todoTitle = todosController.text.toString();
    if (todoTitle.isEmpty) {
      setState(() {
        errorText = " Campo em branco";
      });
    } else {
      var todo = ToDo(title: todoTitle, date: DateTime.now());
      setState(() {
        todos.add(todo);
        errorText = null;
      });
      todosController.clear();
      toDoRepository.saveToDoList(todos);
    }
  }

  void removeAll() {
    if (todos.isEmpty) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Limpar tudo ?"),
          content:
              const Text("tem certeza que deseja apgar todas as tarefas ??"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(primary: Colors.green),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                  todos.clear();
                });
                toDoRepository.saveToDoList(todos);
              },
              style: TextButton.styleFrom(primary: Colors.black),
              child: const Text("Limpar Tudo"),
            )
          ],
        ),
      );
    }
  }

  void onDelete(ToDo todo) {
    deletedTodo = todo;
    deletedPosition = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    toDoRepository.saveToDoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        action: SnackBarAction(
          textColor: Colors.black,
          label: "Desfazer ação",
          onPressed: () {
            setState(() {
              todos.insert(deletedPosition!, deletedTodo!);
            });
            toDoRepository.saveToDoList(todos);
          },
        ),
        content: Text(
          "tarefa ${todo.title} foi removida com sucesso",
          style: const TextStyle(color: Colors.black),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

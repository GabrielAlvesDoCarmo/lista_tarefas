import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/todo.dart';
const todoList = "todo_list";
class ToDoRepository {

  late SharedPreferences sharedPreferences;

  void saveToDoList(List<ToDo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoList, jsonString);
  }

  Future<List<ToDo>> getAllTodoList()  async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String responseList = sharedPreferences.getString(todoList) ?? '[]';
    final List newList = json.decode(responseList) as List;
    return newList.map((e) => ToDo.fromJson(e)).toList();
  }
}

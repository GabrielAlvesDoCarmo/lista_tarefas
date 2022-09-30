class ToDo {
  ToDo({required this.title, required this.date});
  ToDo.fromJson(Map<String,dynamic> jsonTodo) :
    title = jsonTodo['title'],
    date = DateTime.parse(jsonTodo['datetime']);

  String title;
  DateTime date;

  Map<String,dynamic>toJson(){
    return{
      'title' : title,
      'datetime' : date.toIso8601String(),
    };
  }
}

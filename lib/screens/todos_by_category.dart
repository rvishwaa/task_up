import 'package:flutter/material.dart';
import 'package:task_up/models/todo.dart';
import 'package:task_up/service/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  void initState(){
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: const Text('Todos by Category'),
      ),
      body: Column(
        children: <Widget> [
          Expanded(child: ListView.builder(itemCount:_todoList.length,itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)
                ),
                elevation: 4,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget> [
                      Text(_todoList[index].title ?? 'No Title')
                    ],
                  ),
                  subtitle: Text(_todoList[index].description),
                  trailing: Text(_todoList[index].todoDate),
                ),
              ),
            );
          })
          )
        ],
      ),
    );
  }
}

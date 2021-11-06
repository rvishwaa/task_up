import 'package:flutter/material.dart';
import 'package:task_up/helpers/drawer_navigation.dart';
import 'package:task_up/models/todo.dart';
import 'package:task_up/screens/todo_screen.dart';
import 'package:task_up/service/todo_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;
  List<Todo> _todoList = List<Todo>();

  void initState(){
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();
    var todos = await _todoService.readTodo();
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        model.category = todo['category'];
        _todoList.add(model);
      });
    });
  }

  _deleteFormDialog(BuildContext context, todoId){
    return showDialog(context: context, barrierDismissible: true, builder: (param){
      return AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed:() async {
              var result = await _todoService.deleteTodo(todoId);
              Navigator.popUntil(context, (route) => false);
              getAllTodos();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
            },
            child: const Text('Yes'),
          ),
          TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('No')
          ),
        ],
        title: const Text('Are you sure, do you want to delete this category ?'),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Up'),
        backgroundColor: Colors.grey.shade800,
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(itemCount: _todoList.length ,itemBuilder: (context, index){
        return Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text(_todoList[index].title ?? 'No Title')
                  ],
                ),
                subtitle: Text(_todoList[index].category ?? 'No Category'),
                trailing: IconButton(onPressed: (){
                  _deleteFormDialog(context, _todoList[index].id);
                }, icon: const Icon(Icons.delete,
                  color :Colors.red,
                  size: 30,
                )
                ),
              ),
            ),
          );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          Icons.add,
        ),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute
              (builder: (context)=>TodoScreen()));
          getAllTodos();
        }
      )
    );
  }
}


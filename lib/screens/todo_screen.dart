import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_up/models/todo.dart';
import 'package:task_up/screens/home_screen.dart';
import 'package:task_up/service/category_service.dart';
import 'package:intl/intl.dart';
import 'package:task_up/service/todo_service.dart';

class TodoScreen extends StatefulWidget {

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();

  void initState(){
    super.initState();
    _loadCategories();
}

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
    );
    if(_pickedDate!=null){
      setState(() {
        _dateTime = _pickedDate;
        todoDateController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new task'),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget> [
            TextField(
              controller: todoTitleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Write task title',
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Write task description',
              ),
            ),
            TextField(
              controller: todoDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a date',
                suffixIcon: InkWell(
                  onTap: (){
                    _selectedTodoDate(context);
                  },
                  child: const Icon(CupertinoIcons.calendar_today),
                 )
                )
              ),
            DropdownButtonFormField(
              value: _selectedValue,
              items: _categories,
              hint: const Text('Category'),
              onChanged: (value){
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(onPressed: ()async {
              var todoObject = Todo();
              todoObject.title = todoTitleController.text;
              todoObject.description = todoDescriptionController.text;
              todoObject.isFinished = 0;
              todoObject.category = _selectedValue.toString();
              todoObject.todoDate = todoDateController.text;

              var _todoService = TodoService();
              var result = await _todoService.saveTodo(todoObject);
              if(result>0){
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              }
            },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
              ),
              child: const Text('Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

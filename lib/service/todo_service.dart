import 'package:task_up/models/todo.dart';
import 'package:task_up/repositories/repository.dart';

class TodoService{
  Repository _repository;
  TodoService() {
    _repository = Repository();
  }

  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  readTodo() async{
    return await _repository.readData('todos');
  }

  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName('todos', 'category', category);
  }

  deleteTodo(todoId) async {
    return await _repository.deleteData('todos', todoId);
  }
}

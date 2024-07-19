import 'package:hive_data_base/models/TodoModel.dart';
import 'package:hive_flutter/adapters.dart';

class Todoservice {
  Box <Todo>? todoBox;
  Future<void> openBox() async {
    todoBox = await Hive.openBox<Todo>('todos');
  }

//close the data base
  Future<void> closeBox() async {
    await todoBox!.close();
  }

  //create todo
  Future<void> createTodo(Todo todo) async {
    // todoBox == null ? await openBox() : await todoBox!.add(todo);
    if (todoBox == null) {
      await openBox();
    }
    await todoBox!.add(todo);
  }

  //get the tdo values
  Future<List<Todo>> getTodos() async {
    if (todoBox == null) {
      await openBox();
    }
    return todoBox!.values.toList();
  }

  // update todo
  Future<void> updateTodos(int index, Todo todo) async {
    if (todoBox == null) {
      await openBox();
    }
    await todoBox!.putAt(index, todo);
    print("updated");
  }

  //delete todo
  Future<void> deleteTodo(int index) async {
    if (todoBox == null) {
      await openBox();
    }
    await todoBox!.deleteAt(index);
  }
}

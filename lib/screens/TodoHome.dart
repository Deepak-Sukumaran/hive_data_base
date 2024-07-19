// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_data_base/models/TodoModel.dart';
import 'package:hive_data_base/service/TodoService.dart';

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final Todoservice objtodoService = Todoservice();

  List<Todo> fetchTodo = [];

//Load all data from hive db

  Future<void> loadData() async {
    fetchTodo = await objtodoService.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add new todo
          createTodo();
          titleController.clear();
          descriptionController.clear();
          
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("All Tasks"),
      ),
      body: 
      fetchTodo.isEmpty? Text("empty!"):
       Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: fetchTodo.length,
          itemBuilder: (context, index) {
            final todo = fetchTodo[index];
            return Card(
              elevation: 5,
              child: ListTile(
                onTap: () {
                  updateTodo(todo, index);
                },
                leading: CircleAvatar(maxRadius: 20,
                  child: Text("${index + 1}"),
                ),
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: Container(
                  width: 98,
                  child: Row(
                    children: [
                      Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          setState(() {
                            todo.completed = value!;
                            objtodoService.updateTodos(index, todo);
                            setState(() {});
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () async {
                            await objtodoService.deleteTodo(index);
                            loadData();
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> createTodo() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Task"),
          content: Container(
            height: 200,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // title feild
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Title",
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)))
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // description feild
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)))
                  ),
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  final newTodo = Todo(
                      title: titleController.text,
                      description: descriptionController.text,
                      createdAt: DateTime.now(),
                      completed: false);
                  await objtodoService.createTodo(newTodo);
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                  loadData();
                },
                child: Text("Add")),
          ],
        );
      },
    );
  }

  Future<void> updateTodo(Todo todo, int index) async {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Container(
            height: 200,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: "Description"),
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  todo.title = titleController.text;
                  todo.description = descriptionController.text;
                  todo.createdAt = DateTime.now();

                  if (todo.completed == true) {
                    todo.completed = false;
                  }

                  await objtodoService.updateTodos(index, todo);
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                  loadData();
                },
                child: Text("Update"))
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_data_base/models/TodoModel.dart';
import 'package:hive_data_base/screens/TodoHome.dart';
import 'package:hive_data_base/service/TodoService.dart';
import 'package:hive_flutter/adapters.dart';

void main()async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Todoservice().openBox();
  runApp(const MaterialApp(
    home: TodoHome(),
  ));
}

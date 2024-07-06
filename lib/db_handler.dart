import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/model/todo_model.dart';

class DBHandler {
  Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'todo.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE todo (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)
          ''');
        print("Table created");
      },
    );
    return _database;
  }

  Future<void> insert(TodoModel todoModel) async {
    try {
      Database? db = await database;
      final values = todoModel.toMap();
      await db!.insert('todo', values);
      print("Insert method called and data inserted");
    } catch (e) {
      print("Error in insert method: $e");
    }
  }

  Future<List<TodoModel>> get() async {
    try {
      Database? db = await database;
      List<Map<String, dynamic>> list = await db!.query('todo');
      return list.map((e) => TodoModel.fromMap(e)).toList();
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  Future<void> delete(int id) async {
    try {
      Database? db = await database;
      await db!.delete('todo', where: 'id = $id');
      print("Delete method called and data deleted");
    } catch (e) {
      print("Error in delete method: $e");
    }
  }

  Future<void> update(Map<String, dynamic> dataRow) async {
    try {
      Database? db = await database;
      int id = dataRow['id'];
      await db!.update('todo', dataRow, where: 'id = $id');
      print("Update method called and data Update");
    } catch (e) {
      print("Error in Update method: $e");
    }
  }
}

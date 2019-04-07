import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_assignment_02/Models/todo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';


// Column Name
final String TABLE_NAME = "Todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";


class DBHelper{



  static Database db_instance;

  Future<Database> get db async{
    if(db_instance == null){
      db_instance = await initDB();
    }
    return db_instance;
  }

  initDB() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "EDMTDev.db");
    var db = await openDatabase(path, 
    version: 1, 
    onCreate: onCreateFunction);
    return db;
  }

  void onCreateFunction(Database db, int version) async{
    // create Table Todo
    await db.execute('CREATE TABLE $TABLE_NAME($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL, $columnDone INTEGER NOT NULL);');
  }

// Get todo list
  Future<List<Todo>> getAllTodo() async{
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM $TABLE_NAME');
    List<Todo> todos = new List();
    for(int i = 0;i<list.length;i++){
      Todo todo = new Todo();
      todo.id = list[i][columnId];
      todo.title = list[i][columnTitle];
      todo.done = list[i][columnDone];

      todos.add(todo);
    }
    return todos;
  }
// add new todo list
  void addNewTodolist(Todo todo) async{
    var db_connection = await db;
    String query = 'INSERT INTO $TABLE_NAME(title, done) VALUES(\'${todo.title}\', false)';
    await db_connection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });
  }
//Update todolist
  void update(Todo todo) async{
    var db_connection = await db;
    String query = 'UPDATE $TABLE_NAME SET $columnTitle=\'${todo.title}\', $columnDone=\'${todo.done}\' WHERE $columnId=${todo.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

  //Delete todolist
  void delete(Todo todo) async{
    var db_connection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE $columnId=${todo.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }
}
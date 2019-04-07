import 'package:sqflite/sqflite.dart';

// Column Name
final String tableName = "todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo{
  final int id;
  final String title;
  final bool done;

  Todo(this.id, this.title, this.done);
  
}
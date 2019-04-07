import 'package:sqflite/sqflite.dart';

final String tableName = "todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo{
  int _id;
  String title;
  bool done;

  Todo();

  Map<String, dynamic> mapping() {
    Map<String, dynamic> map={
      columnTitle: title,
      columnDone: done,
    };
    if (_id != null) map[columnId] = _id;
    return map;
  }

  Todo.formMap(Map<String, dynamic> map) {
    this._id = map[columnId];
    this.title = map[columnTitle];
    this.done = map[columnDone] == 1; //check todo is done ?
  }
  
}

class TodoProvide{
  Database db;
  Future open(String path) async{
    db = await openDatabase(path, version:1,
      onCreate: (Database db, int version) async{
        await db.execute('CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL, $columnDone INTEGER NOT NULL)');
      }
    );
  }

  Future<Todo> addTodo(Todo todo) async{
    todo._id = await db.insert(tableName, todo.mapping());
    return todo;
  }

  Future<Todo> getTodo(int id) async{
    List<Map> maps = await db.query(tableName,
    columns: [columnId, columnTitle, columnDone],
    where: '$columnId = ?',
    whereArgs: [id]
    
    );
    if(maps.length > 0){
      return new Todo.formMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async{
    return await db.delete(tableName, 
    where: '$columnId = ?',
    whereArgs: [id]);
  }

  Future<int> update(Todo todo) async{
    return await db.update(tableName, todo.mapping(),
    where: '$columnId = ?', whereArgs: [todo._id]);
  }

  Future<List<Todo>> getAllDone() async{
    var todo = await db.query(tableName,
      where: '$columnDone = 1'
    );
    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<List<Todo>> getAllTodos() async{
    var todo = await db.query(tableName,
      where: '$columnDone = 0'
    );
    return todo.map((f) => Todo.formMap(f)).toList();
  }

  Future<void> deleteAllDone() async{
    await db.delete(tableName,
      where: '$columnDone = 1'
    );
  }

  Future closeDB() async => db.close();

}
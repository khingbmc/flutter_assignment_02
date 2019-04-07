import 'package:flutter_assignment_02/Database/DBHelper.dart';
import 'package:flutter_assignment_02/Models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/ui/add_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';


Future<List<Todo>> getTodoListFromDB() async{
    var dbHelper = DBHelper();
    Future<List<Todo>> todos = dbHelper.getAllTodo();
  }

class TodoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoScreenState();
  }

}



class TodoScreenState extends State<TodoScreen> {
  final controller_title = new TextEditingController();
  int _current_state = 0;
  int countTodo = 0;
  int countDone = 0;
  Todo todo = new Todo();

  String title;
  int done;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text("Todo"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              addTodoList();
              },
          )
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Todo>>(
          future: getTodoListFromDB(),
          builder: (context, snapshot) {
            if(snapshot.data != null) {
              if(snapshot.hasData){
                countTodo = snapshot.data.length;
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index){
                    if(snapshot.data[index].done == 0){
                      return new Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                snapshot.data[index].title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )

                          ],),
                        )
                      ],
                    );
                    }
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  void addTodoList() {
  // add Todo list
  Navigator.push(context, new MaterialPageRoute(builder: (context) => new TodoAdd()));
  }

  
  
}
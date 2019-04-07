import 'package:flutter/material.dart';
import './add_screen.dart';
import 'package:flutter_assignment_02/Models/todo.dart';

class TodoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoScreenState();
  }

}

class TodoScreenState extends State{
  
  int _curState = 0;
  int countList = 0;
  int countDone = 0;
  List<Todo> todos;
  List<Todo> todosDone;

  TodoProvide db = TodoProvide();

  void getTodos() async{
    await db.open("todo.db");
    db.getAllTodos().then((todos){
      setState(() {
              this.countList = todos.length;
              this.todos = todos;
            });
    });
    db.getAllDone().then((todosDone){
      setState(() {
              this.countDone = todosDone.length;
              this.todosDone = todosDone;
            });
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List current_tab = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => TodoAdd()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: (){
          db.deleteAllDone();
        },
      )
    ];

  //change tab (task, complete) => store in list current screen
    List current_screen = [
      countList == 0 ? Text("No data found.."):
      ListView.builder(
        itemCount: countList,
        itemBuilder: (context, int index){
          return Column(
            children: <Widget>[
              Divider(height: 7.0,),
              ListTile(
                title: Text(this.todos[index].title,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 24,
                ),),
                trailing: Checkbox(
                  onChanged: (bool val){
                    setState(() {
                      todos[index].done = val;
                    });
                    db.update(todos[index]);
                  },
                  value: todos[index].done,
                ),
              )
            ],
          );
        },
      ),
      countDone == 0 ? Text("No data found.."):
      ListView.builder(
        itemCount: countDone,
        itemBuilder: (context, int index){
          return Column(
            children: <Widget>[
              Divider(height: 7.0,),
              ListTile(
                title: Text(this.todosDone[index].title,
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 24,
                  ),
                ),
                trailing: Checkbox(
                  onChanged: (bool val){
                    setState(() {
                      todosDone[index].done = val;
                    });
                    db.update(todosDone[index]);
                  },
                  value: todosDone[index].done,
                ),

              )
            ],
          );
        },
      )
    ];

    getTodos();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
          actions: <Widget>[
            _curState == 0 ? current_tab[0] : current_tab[1], 

          ],
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: _curState == 0 ? current_screen[0] : current_screen[1],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _curState,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Task')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: Text('Completed')
            )
          ],
          onTap: (int index){
            setState(() {
              _curState = index;
            });
          },
        ),
      ),
    );
  }

}
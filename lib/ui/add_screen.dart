import 'package:flutter_assignment_02/Database/DBHelper.dart';
import 'package:flutter_assignment_02/Models/todo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoAdd extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoAddState();
  }

}



class TodoAddState extends State<StatefulWidget> {
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
      ),
      body: new Padding(padding: const EdgeInsets.all(16.0),
      child: new Form(
        key: formKey,
        child: new Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: new InputDecoration(labelText: "Subject"),
              validator: (val) => val.length == 0 ? "Please fill subject":null,
              onSaved: (val) => this.title = val,
            ),
            new Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: new RaisedButton(
                onPressed: saveList,
                child: Text("Save"),
              ),
            )
          ],
        ),
      ),),
    );
  }

  void startTodoList() {
  // add Todo list

  }

  void saveList(){
    if(this.formKey.currentState.validate()){
      formKey.currentState.save();
    }else{
      return null;
    }

    var todo = Todo();
    todo.title = title;
    todo.done = done;

    var dbHelper = DBHelper();
    dbHelper.addNewTodolist(todo);
    Fluttertoast.showToast(msg: "Todo was saved", toastLength: Toast.LENGTH_SHORT, backgroundColor: Color(0xFFFFFF), textColor: Color(0x333333));
  }
  
}
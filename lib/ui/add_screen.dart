import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Models/todo.dart';

class TodoAdd extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodoAddState();
  }

}

class TodoAddState extends State<StatefulWidget>{
  final _formkey = GlobalKey<FormState>();
  TextEditingController subjectTodo = TextEditingController();
  TodoProvide db = TodoProvide();
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: subjectTodo,
                decoration: InputDecoration(labelText: 'Subbject'),
                validator: (value){
                  if(value.isEmpty) return "Please fill subject";
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () async{
                  _formkey.currentState.validate();
                  if (subjectTodo.text.isNotEmpty){
                    await db.open("todo.db");
                    Todo todo = Todo();
                    todo.title = subjectTodo.text;
                    todo.done = false;
                    await db.addTodo(todo);
                    Navigator.pop(context, true);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}
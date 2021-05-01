import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO-List',
      home: ToDoList()
    );
  }
}


class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<String>_todoitems=[];
  
  void _addTodoItem(String task){
    if(task.length > 0) {
      setState(() => _todoitems.add(task));
    }
  }
void _removeTodoItem(int index) {
  setState(() => _todoitems.removeAt(index));
}

void _promptRemoveTodoItem (int index) {
  showDialog(
    context: context,
     builder: (BuildContext context ) {
       return AlertDialog(
         title: Text('Mark"${_todoitems[index]}"as done?'),
         actions:<Widget> [
           FlatButton(
             onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel")
             ),
             FlatButton(
               onPressed: () {
                 _removeTodoItem(index);
                 Navigator.of(context).pop();
               },
                child: Text("Mark as done")
                )
         ]
       );
     }
    );
}

  Widget _buildtodolist() {
    return ListView.builder(
      itemBuilder:(context,index){
        if(index < _todoitems.length) {
          return _buildtodoItem(_todoitems[index],index);
        }
      },
      );
  }
  Widget _buildtodoItem(String todoText, int index) {
    return ListTile(
      title:Text(todoText),
      onTap: () => _promptRemoveTodoItem(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("ToDo List") ,
        ),
        body: _buildtodolist(),
        floatingActionButton: FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: "Add Task",
          child: Icon(Icons.add),
        ),
    );
  }

  void _pushAddTodoScreen(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add a new Task"),
            ),
            body: TextField(
              autofocus: true ,
              onSubmitted: (val){
                _addTodoItem(val);
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: "enter something to do ...",
                contentPadding: const EdgeInsets.all(16.0) 
                ),
              )
          );
        }
        )
    );
  }

}
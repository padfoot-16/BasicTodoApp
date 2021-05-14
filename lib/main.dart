import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  List<String>done=[];
  List<String>description=[];
  String task="";
  
  void _addTodoItem(String task) async{

    final prefs=await SharedPreferences.getInstance();
    if(task.length > 0) {
      setState(() => _todoitems.add(task));
      prefs.setStringList('todoitems', _todoitems);
    }
  }
void _removeTodoItem(int index) {
  setState(() { done.add(_todoitems[index]);
  _todoitems.removeAt(index);
  });
}

void _promptRemoveTodoItem (int index) {
  showDialog(
    context: context,
     builder: (BuildContext context ) {
       return AlertDialog(
         title: Text('Mark"${_todoitems[index]}"as done?'),
         actions:<Widget> [
           // ignore: deprecated_member_use
           FlatButton(
             onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel")
             ),
             // ignore: deprecated_member_use
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
  Future<Widget> readdata() async{
    final prefs =await SharedPreferences.getInstance();
    _todoitems= prefs.getStringList('todoitems');
    return _buildtodolist();
  }
  Widget _buildtodolist() {
    return ListView.builder(
      itemCount: _todoitems.length,
      // ignore: missing_return
      itemBuilder:(context,index){
        if(index < _todoitems.length) {
          return _buildtodoItem(_todoitems[index],index);
        }
      },
      );
  }
  Widget _buildtodoItem(String todoText, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 4.0),
      child: Card(
            child: ListTile(
          title:Text(todoText),
          contentPadding: EdgeInsets.all(8.0),
          //isThreeLine: true,
          
          onTap: () => _promptRemoveTodoItem(index),
        ),
      ),
    );
  }
  void _pushSaved() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => compTasks()));   
  }
Widget compTasks() {
  return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body:ListView.builder(
          itemCount: done.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(done[index]),
              onTap: () =>rmdata(index),
            );
  }
    )
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("ToDo List") ,
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
        ),
        body: _buildtodolist(),
        floatingActionButton: FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: "Add Task",
          child: Icon(Icons.add),
        ),
    );
  }
void rmdata( int index)async{
  final prefs=await SharedPreferences.getInstance();
setState(() {
done.removeAt(index);
});
prefs.remove('todoitems');
}
  void _pushAddTodoScreen(){
    showDialog(
    context: context,
     builder: (BuildContext context ) {
       return AlertDialog(
         title: Text("Add a Task"),
         content: TextField(
           autofocus: true,
           onSubmitted: (val){
                _addTodoItem(val);
                Navigator.pop(context);
              },
           decoration: InputDecoration(
                hintText: "enter something to do ...",
                contentPadding: const EdgeInsets.all(16.0) ,
           ),
           onChanged: (String value){
             task=value;
           },
       ),
       actions: [
         // ignore: deprecated_member_use
         FlatButton(
           onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel")
            ),
            // ignore: deprecated_member_use
            FlatButton(
              onPressed:(){
                _addTodoItem(task);
                Navigator.of(context).pop();
              },
             child: Text("Add Task")
             )
       ],
       );
     },
    );
  }
}
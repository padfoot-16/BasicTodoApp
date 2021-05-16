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
    return Column(
        children: [
          Stack(
            children:<Widget>[
              Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              ),
              color: Colors.white,
              ),
            ),
          
          Container(
            height: 80,
            width: 80,
            margin: EdgeInsets.only(top:110,left:MediaQuery.of(context).size.width*0.5-43),
            child: FloatingActionButton(
              child: Icon(Icons.add,size: 60,),
              backgroundColor: Colors.red,
              onPressed:_pushAddTodoScreen,
            ), 
          ),
            ]
          ),
              Expanded(
              
              child: ListView.builder(
                itemCount: _todoitems.length,
                
                // ignore: missing_return
                itemBuilder:(context,index){
                  if(index < _todoitems.length) {
                    return _buildtodoItem(_todoitems[index],index);
                  }
                },
                ),
                      
            ) 
        ],
      );   
  }
  Widget _buildtodoItem(String todoText, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 4.0),
      child: Card(
            child: ListTile(
          title:Text(todoText,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          subtitle: Text("this is a subttitle"),
          contentPadding: EdgeInsets.all(8.0),
          //isThreeLine: true,
          
          onTap: () => _promptRemoveTodoItem(index),
        ),
      ),
    );
  }
  
Widget compTasks() {
  return Column(
        children: [
          Stack(
            children:<Widget>[
              Container(
                padding: EdgeInsets.only(left:20),
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
              ),
              color: Colors.white,
              ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget> [
              Text("Completed Tasks",style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold)),
              Container(),
            ],
            )
          ),
            ]
          ),
              Expanded(
              child: ListView.builder(
              itemCount: done.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 1),
                   child: Card(
                        child: ListTile(
                        title: Text(done[index]),
                          onTap: () =>rmdata(index),
                         ),
                  ),
                );
  }
    ),
              )
        ],
      );   
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
      body:new TabBarView(
              children: [
         _buildtodolist(),
         compTasks(),

              ],
      ),
      appBar: AppBar(
        elevation: 0,
        title:TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home),),
            Tab(icon: Icon(Icons.list),),
            
          ],
          labelColor: Colors.yellow,
          unselectedLabelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Colors.white,
          ),
          backgroundColor: Colors.white,
      ),
        backgroundColor: Colors.grey,
          )
          )
      )
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
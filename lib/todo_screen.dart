import 'package:flutter/material.dart';
import 'apiConfig.dart';
import 'model.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  
    final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

    List<Todo> _todo = [];
    bool _isloading = false;
     
    @override
      void initState() {
        _isloading = true;
       TodoUtils.fetchTodo().then((resp) {
         print(resp);
         for (var todo in resp) {
         setState(() {
           _todo.add(Todo.fromJson(todo));
           _isloading = false;
         });
      }
    });
    super.initState();
  }
    @override
  
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldkey,
            body: CustomScrollView(
             slivers: <Widget>[
               SliverAppBar(
                 pinned: true,
                 snap: true,
                title: Text('Floating app bar'),
                floating: true,
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(
                      "lib/img/todo.jpg",
                      fit: BoxFit.cover,
                      ))
                  ],
                ),
                expandedHeight: 200,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                (context, index) => Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(_todo[index].task,
                       style: TextStyle(
                         fontSize: 21
                       ),
                      ),
                      subtitle: Text('Created At'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.pink[400],), 
                            onPressed: (){
                              showTodUpdateDialog(_todo[index]);
                            }
                            ),
                            IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.green,), 
                            onPressed: (){
                              showDeleteTodoDialog(_todo[index].objectId);
                            }
                            ),
                        ],
                      ),
                      ),
                  )
                    ),
                childCount: _todo.length,
              ))
              
             ]
            ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
            showAddTodoDialog();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
      ),
      
    );
  }


  TextEditingController _taskController = TextEditingController();

  void showAddTodoDialog() {

    showDialog(context: context,
      builder: (_) => AlertDialog(
        content: Container(
          width: double.maxFinite,
          child: TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: "Enter task",
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(onPressed: () {

            Navigator.pop(context);
            addTodo();

          }, child: Text("Add")),
          FlatButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      )
    );

  }

  void showTodUpdateDialog(Todo todo) {
    _taskController.text = todo.task;
    showDialog(context: context,
     builder: (_) => AlertDialog(
       content: Container(
          width: double.maxFinite,
          child: TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: "Enter updated task",
            ),
          ),
        ),
         actions: <Widget>[
          FlatButton(onPressed: () {
            Navigator.pop(context);
            todo.task = _taskController.text;
            updateTodo(todo);
          }, child: Text("Update")),
          FlatButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
     )
    );

  }

   void showDeleteTodoDialog(String objectId) {

    showDialog(context: context,
      builder: (_) => AlertDialog(
        content: Container(
          width: double.maxFinite,
          child: Text('Are You Sure You Want To Delete ?'),
        ),
        actions: <Widget>[
          FlatButton(onPressed: () {

            Navigator.pop(context);
             deleteTodo(objectId);

          }, child: Text("Delete")),
          FlatButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel")),
        ],
      )
    );

  }

  void addTodo() {
    _scaffoldkey.currentState.showSnackBar(SnackBar(content: Row(
      children: <Widget>[
        Text("Adding task"),
        CircularProgressIndicator(),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
      duration: Duration(minutes: 1),
    ));

    TodoAdd todo = TodoAdd(task: _taskController.text);
    TodoUtils.addTodo(todo).then((res) {
      _scaffoldkey.currentState.hideCurrentSnackBar();
       final response = res;
       if(response.statusCode == 201) {
          _taskController.text = "";
          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Todo added!"), duration: Duration(seconds: 1),));
          setState(() {
          
        });
       }
    });
  }

  void updateTodo(todo) {
     _scaffoldkey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Updating todo"),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);

    TodoUtils.updateTodo(todo).then((resp) {
       _scaffoldkey.currentState.hideCurrentSnackBar();
       final response = resp;
       if(response.statusCode == 200) {
          _taskController.text = "";
          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Todo updated!"), duration: Duration(seconds: 1),));
          setState(() {
          
        });
       }
    });
  }

  void deleteTodo(String objectId) {
   _scaffoldkey.currentState.showSnackBar(SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:  <Widget>[
        Text("Deleting todo"),
        CircularProgressIndicator(),
      ],
    ),
      duration: Duration(minutes: 1),
    ),);

    TodoUtils.deleteTodo(objectId).then((resp) {
       _scaffoldkey.currentState.hideCurrentSnackBar();
       final response = resp;
       if(response.statusCode == 200) {
          _taskController.text = "";
          _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text("Todo deleted!"), duration: Duration(seconds: 1),));
          setState(() {
          
        });
       }
    });
  }

}




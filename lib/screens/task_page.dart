import 'package:flutter/material.dart';
import 'package:goals_todo/database_helper.dart';
import 'package:goals_todo/models/task_model.dart';
import 'package:goals_todo/models/todo_model.dart';
import 'package:goals_todo/widgets.dart';

class TaskPage extends StatefulWidget {

  final Task task;
  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {

    if (widget.task != null) {
      // Set visibility to true
      _contentVisible = true;

      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();


    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                'assets/images/back_arrow_icon.png'
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                              focusNode: _titleFocus,
                              onSubmitted: (value) async {
                                print("Field value:, $value");
                                DatabaseHelper _dbHelper = DatabaseHelper();

                                // Check if the value is not empty
                                if (value != ""){

                                  if(widget.task == null){
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    Task _newtask = Task(
                                        title: value
                                    );
                                    _taskId = await _dbHelper.insertTask(_newtask);
                                    setState(() {
                                      _contentVisible= true;
                                      _taskTitle = value;
                                    });
                                  } else {
                                    await _dbHelper.updateTaskTitle(_taskId, value);
                                    print("Task updated");
                                  }

                                  _descriptionFocus.requestFocus();
                                }

                              },
                              controller: TextEditingController()..text = _taskTitle  ,
                              decoration: InputDecoration(
                                hintText: "Enter Tasks Title",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF211551),
                              ),
                            ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if(value != "") {
                            if(_taskId != 0) {
                              await _dbHelper.updateDesc(_taskId, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus.requestFocus();
                        },
                        controller: TextEditingController()..text = _taskDescription,
                        decoration: InputDecoration(
                          hintText: "Enter description of tasks",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getToDo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  // Switch the completion state
                                  if(snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(snapshot.data[index].id, 0);
                                  }
                                  setState(() {});
                                  print("Todo Done: ${snapshot.data[index].isDone}");

                                },
                                child: ToDoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0 ? false : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                                right: 12.0
                            ),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Color(0xFF86829D),
                                    width: 1.5
                                )
                            ),
                            child: Image(
                              image: AssetImage(
                                'assets/images/check_icon.png',
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                print("Field value:, $value");
                                DatabaseHelper _dbHelper = DatabaseHelper();

                                // Check if the value is not empty
                                if (value != ""){

                                  if(_taskId != 0){
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    ToDo _newToDo = ToDo(
                                      title: value,
                                      isDone: 0,
                                      taskId: _taskId,
                                    );
                                    await _dbHelper.insertToDo(_newToDo);
                                    setState(() {});
                                    _todoFocus.requestFocus();
                                    print("Creating new Todo");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter To do tasks...",
                                border: InputBorder.none,
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  ]
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () async {
                      if(_taskId !=0) {
                        await _dbHelper.deleteTask(_taskId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Color(0xFFFE3577)
                      ),
                      child: Image(
                        image: AssetImage(
                          "assets/images/delete_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

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

  @override
  void initState() {

    if (widget.task != null) {
      _taskTitle = widget.task.title;
      _taskId = widget.task.id;
    }
    super.initState();
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
                                    await _dbHelper.insertTask(_newtask);
                                  } else {
                                    print("Update the existing task");
                                  }
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter description of tasks",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        )
                      ),
                    ),
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getToDo(_taskId),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // Switch the completion state

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
                  Expanded(
                    child: ListView(
                      children: [
                        Text("List View Text")
                      ],
                    ),
                  ),
                  Padding(
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
                            onSubmitted: (value) async {
                              print("Field value:, $value");
                              DatabaseHelper _dbHelper = DatabaseHelper();

                              // Check if the value is not empty
                              if (value != ""){

                                if(widget.task != null){
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  ToDo _newToDo = ToDo(
                                    title: value,
                                    isDone: 0,
                                    taskId: widget.task.id,
                                  );
                                  await _dbHelper.insertToDo(_newToDo);
                                  setState(() {});
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
                  )
                  ]
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskPage()
                      ),
                    );
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
              )
            ],
          )
        ),
      ),
    );
  }
}

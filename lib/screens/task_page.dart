import 'package:flutter/material.dart';
import 'package:goals_todo/database_helper.dart';
import 'package:goals_todo/models/task_model.dart';
import 'package:goals_todo/widgets.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
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
                                if (value != ""){
                                    DatabaseHelper _dbHelper = DatabaseHelper();
                                    Task _newtask = Task(
                                      title: value
                                    );
                                    await _dbHelper.insertTask(_newtask);

                                    print("New task has been created");
                                }

                              },
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
                  ToDO(
                    text: "Create 1st Todo",
                    isDone: false,
                  ),
                  ToDO(
                    text: "Create 1st Todo",
                    isDone: true,
                  ),
                  ToDO(
                    text: "Create 1st Todo",
                    isDone: false,
                  ),
                  ToDO(
                    isDone: true,
                  ),
                ],
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

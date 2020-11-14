import 'package:goals_todo/models/task_model.dart';
import 'package:goals_todo/models/todo_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  Future<Database> database() async {
    return openDatabase(
        join(await getDatabasesPath(), 'todo.db'),
        onCreate: (db, version) async {
          // Run the CREATE TABLE statement on the database.
          await db.execute(
            "CREATE TABLE tasks_table(id INTEGER PRIMARY KEY, title TEXT, description TEXT)",
          );
          await db.execute(
            "CREATE TABLE todo_table(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)",
          );

          return db;

        },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db.insert('tasks_table', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> insertToDo(ToDo todo) async {
    Database _db = await database();
    await _db.insert('todo_table', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks_table SET title = '$title' WHERE id = $id");
  }

  Future<void> updateDesc(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks_table SET description = '$description' WHERE id = $id");
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo_table SET isDone = '$isDone' WHERE id = $id");
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks_table');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description']
      );
    });
  }

  Future<List<ToDo>> getToDo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo_table WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return ToDo(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone'],
      );
    });
  }


  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks_Table WHERE id = $id");
    await _db.rawDelete("DELETE FROM todo_table WHERE taskId = $id");
  }
}
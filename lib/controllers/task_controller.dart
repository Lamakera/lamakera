import 'package:get/get.dart';
import 'package:lamakera/services/db_helper.dart';
import 'package:lamakera/models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  void markTaskAsCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }

  Future<void> updateTask(Task task) async {
  await DBHelper.updateTask(task);
  getTasks();
}

}

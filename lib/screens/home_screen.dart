import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lamakera/helper/db_helper.dart';
import 'add_task_screen.dart';
import 'package:lamakera/styles/fonts.dart';
import 'package:lamakera/styles/colors.dart';
import '../model/todo.dart';
import '../widget/todo_item.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyMainPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<ToDo> _todoList = [];
  List<ToDo> _completedTodoList = [];

  @override
  void initState() {
    super.initState();
  }

  void _toggleToDoStatus(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });

    dbHelper.update(todo.toMap());
  }

  void _deleteToDoItem(int id) {
    dbHelper.delete(id);

    setState(() {
      _todoList.removeWhere((item) => item.id == id);
      _completedTodoList.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.vibrantViolet,
          elevation: 0,
          flexibleSpace: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -85,
                right: 20,
                left: 20,
                child: SvgPicture.asset(
                  'lib/assets/icons/welcome.svg',
                  height: 130,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100.0),
            Text(
              "Tugasku",
              style: AppTextStyles.h2.copyWith(
                color: AppColors.royalPurple,
              ),
            ),
            const SizedBox(height: 20.0),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: dbHelper.getAllTasksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada tugas',
                          style: TextStyle(color: Colors.grey)));
                }

                final data = snapshot.data!;
                final todoList = data
                    .map((item) => ToDo.fromMap(item))
                    .where((item) => !item.isDone)
                    .toList();

                if (todoList.isEmpty) {
                  return const Center(
                      child: Text(
                    'Tidak ada tugas',
                    style: TextStyle(color: Colors.grey),
                  ));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    final todo = todoList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ToDoItem(
                        todo: todo,
                        onToDoChanged: _toggleToDoStatus,
                        onDeleteItem: _deleteToDoItem,
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20.0),
            Text(
              "Selesai",
              style: AppTextStyles.h2.copyWith(
                color: AppColors.royalPurple,
              ),
            ),
            const SizedBox(height: 20.0),
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: dbHelper.getAllTasksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data ?? [];
                final completedTodoList = data
                    .map((item) => ToDo.fromMap(item))
                    .where((item) => item.isDone)
                    .toList();

                if (completedTodoList.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada yang selesai",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: completedTodoList.length,
                  itemBuilder: (context, index) {
                    final todo = completedTodoList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ToDoItem(
                        todo: todo,
                        onToDoChanged: _toggleToDoStatus,
                        onDeleteItem: _deleteToDoItem,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahTugasPage()),
          ).then((_) {});
        },
        child: const Icon(Icons.add),
        backgroundColor: AppColors.vibrantViolet,
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
      ),
    );
  }
}

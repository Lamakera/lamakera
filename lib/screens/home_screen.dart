import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lamakera/helper/db_helper.dart';
import 'add_task_screen.dart';
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
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() async {
    final data = await dbHelper.queryAllRows();
    setState(() {
      _todoList = data.map((item) => ToDo.fromMap(item)).toList();
    });
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppColors.vibrantViolet,
          elevation: 0,
          flexibleSpace: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -70,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 60.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  final todo = _todoList[index];
                  return ToDoItem(
                    todo: todo,
                    onToDoChanged: _toggleToDoStatus,
                    onDeleteItem: _deleteToDoItem,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahTugasPage()),
          ).then((_) {
            _refreshData();
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: AppColors.vibrantViolet,
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
      ),
    );
  }
}

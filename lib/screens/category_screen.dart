import 'package:flutter/material.dart';
import 'package:lamakera/styles/fonts.dart';
import 'package:lamakera/styles/colors.dart';
import 'package:lamakera/helper/db_helper.dart';
import '../model/todo.dart';
import '../widget/todo_item.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  String selectedCategory = 'Kerja'; // Kategori default
  List<Map<String, dynamic>> taskList = []; // Data tugas dari SQLite
  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Inisialisasi helper

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Ambil data dari database saat halaman dimuat
  }

  Future<void> _fetchTasks() async {
    final data = await _databaseHelper.queryAllRows();
    setState(() {
      taskList = data;
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter tugas berdasarkan kategori yang dipilih
    List<Map<String, dynamic>> filteredTasks =
        taskList.where((task) => task['category'] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.vibrantViolet,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol filter kategori
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _filterByCategory('Kerja'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Kerja'
                        ? AppColors.vibrantViolet
                        : Colors.grey[200],
                    foregroundColor: selectedCategory == 'Kerja'
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Kerja'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _filterByCategory('Kuliah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Kuliah'
                        ? AppColors.vibrantViolet
                        : Colors.grey[200],
                    foregroundColor: selectedCategory == 'Kuliah'
                        ? Colors.white
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Kuliah'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Judul daftar tugas
            Text(
              'Tugasku',
              style: AppTextStyles.h2.copyWith(color: AppColors.vibrantViolet),
            ),
            const SizedBox(height: 10),

            // Daftar tugas
            // Expanded(
            //   child: filteredTasks.isEmpty
            //       ? const Center(child: Text('Tidak ada tugas'))
            //       : ListView.builder(
            //           itemCount: filteredTasks.length,
            //           itemBuilder: (context, index) {
            //             final task = filteredTasks[index];
            //             return ToDoItem(
            //               todo: ToDo(
            //                 id: task['id'],
            //                 todoText: task['todoText'],
            //                 category: task['category'],
            //                 deadline: task['deadline'],
            //                 isDone: task['isDone'] == 1,
            //               ),
            //               onToDoChanged: (updatedTodo) async {
            //                 // Update status tugas di database
            //                 await _databaseHelper.update({
            //                   'id': task['id'],
            //                   'todoText': task['todoText'],
            //                   'category': task['category'],
            //                   'deadline': task['deadline'],
            //                   'isDone': updatedTodo.isDone ? 1 : 0,
            //                 });
            //                 _fetchTasks();
            //               },
            //               onDeleteItem: (id) async {
            //                 // Hapus tugas dari database
            //                 await _databaseHelper.delete(id);
            //                 _fetchTasks();
            //               },
            //             );
            //           },
            //         ),
            // ),
          ],
        ),
      ),
    );
  }
}

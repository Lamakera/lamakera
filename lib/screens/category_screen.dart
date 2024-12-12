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
  String selectedCategory = 'Kerja'; 
  List<Map<String, dynamic>> taskList = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchTasks(); 
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
    
    List<Map<String, dynamic>> filteredTasks =
        taskList.where((task) => task['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Kategori',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.mediumPurple,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                ElevatedButton(
                  onPressed: () => _filterByCategory('Kerja'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Kerja'
                        ? AppColors.vibrantViolet
                        : AppColors.lavenderBlush,
                    foregroundColor: selectedCategory == 'Kerja'
                        ? Colors.white
                        : AppColors.vibrantViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 5,
                  ),
                  child: Text('Kerja'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _filterByCategory('Kuliah'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Kuliah'
                        ? AppColors.vibrantViolet
                        : AppColors.lavenderBlush,
                    foregroundColor: selectedCategory == 'Kuliah'
                        ? Colors.white
                        : AppColors.vibrantViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.grey,
                    elevation: 5,
                  ),
                  child: const Text('Kuliah'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            
            Text(
              'Tugasku',
              style: AppTextStyles.h2.copyWith(color: AppColors.vibrantViolet),
            ),
            const SizedBox(height: 20),

            
            Expanded(
              child: filteredTasks.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = ToDo.fromMap(filteredTasks[index]);
                        return ToDoItem(
                          todo: task,
                          onToDoChanged: (updatedTask) async {
                            await _databaseHelper.update(updatedTask.toMap());
                            _fetchTasks();
                          },
                          onDeleteItem: (id) async {
                            await _databaseHelper.delete(id);
                            _fetchTasks();
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Tidak ada tugas di kategori ini',
                        style: AppTextStyles.subhead1Regular,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

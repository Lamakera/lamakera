import 'package:flutter/material.dart';
import 'package:lamakera/assets/size_config.dart';
import 'package:lamakera/assets/theme.dart';
import '../../models/task.dart';
import 'package:lamakera/widgets/task_tile.dart';
import 'package:lamakera/services/db_helper.dart'; 

class MyCategory extends StatefulWidget {
  const MyCategory({Key? key}) : super(key: key);

  @override
  _MyCategoryState createState() => _MyCategoryState();
}

class _MyCategoryState extends State<MyCategory> {
  String selectedCategory = "Kuliah"; // Default category

  Future<List<Task>> getTasksByCategory(String category) async {
    List<Map<String, dynamic>> taskMaps =
        await DBHelper.queryByCategory(category);
    return List.generate(taskMaps.length, (i) {
      return Task.fromJson(taskMaps[i]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showCategoryDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: getTasksByCategory(
            selectedCategory), // Mengambil tugas berdasarkan kategori yang dipilih
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada tugas'));
          }

          List<Task> tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return TaskTile(tasks[index]); // Gunakan TaskTile di sini
            },
          );
        },
      ),
    );
  }

  // Dialog untuk memilih kategori
  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Kategori'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Kuliah'),
                onTap: () {
                  setState(() {
                    selectedCategory = "Kuliah";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Kerja'),
                onTap: () {
                  setState(() {
                    selectedCategory = "Kerja";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

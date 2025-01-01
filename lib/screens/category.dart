import 'package:flutter/material.dart';
import 'package:lamakera/assets/size_config.dart';
import 'package:lamakera/assets/theme.dart';
import '../../models/task.dart';
import 'package:lamakera/widgets/task_tile.dart';
import 'package:lamakera/services/db_helper.dart';
import 'package:get/get.dart';

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
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Kategori Tugas',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.5), // Opacity added
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {
                _showCategoryDialog();
              },
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 30.0, left: 30.0, right: 16.0), // Adding margin to the body
        child: Column(
          children: [
            SizedBox(height: 16.0), // Adding space between AppBar and content
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: getTasksByCategory(selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: \${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada tugas'));
                  }

                  List<Task> tasks = snapshot.data!;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskTile(tasks[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
                title: Text(
                  'Kuliah',
                  style: titleStyle, // Applying titleStyle
                ),
                onTap: () {
                  setState(() {
                    selectedCategory = "Kuliah";
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Kerja',
                  style: titleStyle, // Applying titleStyle
                ),
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

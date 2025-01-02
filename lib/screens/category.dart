import 'package:flutter/material.dart';
import 'package:lamakera/assets/size_config.dart';
import 'package:lamakera/assets/theme.dart';
import '../../models/task.dart';
import 'package:lamakera/widgets/task_tile.dart';
import 'package:lamakera/services/db_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Library untuk SVG

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
        // backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: Text(
          'Kategori Tugas',
          style: headingStyle,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: primaryClr.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
              icon: Icon(
                Icons.list,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                _showCategoryDialog();
              },
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Task>>(
                future: getTasksByCategory(selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'images/task.svg', // Path SVG baru
                            height: 200,
                            width: 200,
                            semanticsLabel: 'Task Empty',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Kamu belum memiliki tugas!',
                            style: subTitleStyle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
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
          backgroundColor: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          title: Text(
            'Pilih Kategori',
            style: headingStyle,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Kuliah',
                  style: subTitleStyle,
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
                  style: subTitleStyle,
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

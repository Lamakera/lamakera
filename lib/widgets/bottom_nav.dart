import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamakera/screens/home_page.dart';
import 'package:lamakera/screens/category.dart';
import 'package:lamakera/screens/add_task_screen.dart';
import 'package:lamakera/controllers/nav_controller.dart';
import 'package:lamakera/assets/theme.dart';

class MyBottom extends StatelessWidget {
  const MyBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController bottomNavController =
        Get.put(BottomNavController());

    return Scaffold(
      body: Obx(() {
        switch (bottomNavController.currentIndex.value) {
          case 0:
            return HomePage();
          case 1:
            return MyCategory();
          default:
            return HomePage();
        }
      }),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40), // Radius pojok kiri atas
          topRight: Radius.circular(40), // Radius pojok kanan atas
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10.0,
          elevation: 10,
          color: Get.isDarkMode ? darkHeaderClr : bluishClr,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.list,
                    color: bottomNavController.currentIndex.value == 0
                        ? Colors.white
                        : Colors.white,
                  ),
                  onPressed: () {
                    bottomNavController.updateIndex(0);
                  },
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: Icon(
                    Icons.category_outlined,
                    color: bottomNavController.currentIndex.value == 1
                        ? Colors.white
                        : Colors.white,
                  ),
                  onPressed: () {
                    bottomNavController.updateIndex(1);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskPage()),
            );
          },
          backgroundColor: pinkClr,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
          elevation: 4,
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

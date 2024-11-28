import 'package:flutter/material.dart';
import 'package:lamakera/screens/home_screen.dart';
import 'package:lamakera/screens/my_bottom.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MyBottom());
  }
}

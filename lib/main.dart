import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lamakera/services/db_helper.dart';
import 'package:lamakera/services/theme_services.dart';
import 'package:lamakera/assets/theme.dart';
import 'package:lamakera/widgets/bottom_nav.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyBottom(),
    );
  }
}

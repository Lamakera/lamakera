import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
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
    final box = GetStorage();
    bool isOnboardingComplete = box.read('onboardingComplete') ?? false;

    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: isOnboardingComplete ? const MyBottom() : Onboarding(),
    );
  }
}

class Onboarding extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Lamakera',
      subTitle: 'Plan your day and stay productive',
      imageUrl: 'images/onboarding3.png',
    ),
    Introduction(
      title: 'Manage Your Tasks',
      subTitle: 'Add, edit, and complete your daily goals',
      imageUrl: 'images/onboarding2.png',
    ),
    Introduction(
      title: 'Stay Focused',
      subTitle: 'Categorize and conquer your tasks with ease',
      imageUrl: 'images/onboarding1.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: Colors.white,
      foregroundColor: primaryClr,
      introductionList: list,
      onTapSkipButton: () {
        final box = GetStorage();
        box.write('onboardingComplete', true); // Simpan status onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyBottom(),
          ),
        );
      },
      skipTextStyle: const TextStyle(
        color: primaryClr,
        fontSize: 20,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lamakera/screens/home_screen.dart';
import 'package:lamakera/screens/category_screen.dart';
import 'package:lamakera/screens/calender_screen.dart';
import 'package:lamakera/styles/colors.dart';
import 'package:lamakera/styles/fonts.dart'; 
import 'package:flutter_svg/flutter_svg.dart';

class MyBottom extends StatefulWidget {
  const MyBottom({super.key});

  @override
  State<MyBottom> createState() => _MyBottomState();
}

class _MyBottomState extends State<MyBottom> {
  int _currentindex = 0;
  static List<Widget> _page = <Widget>[
    MyMainPage(),
    KategoriPage(),
    KalenderPage(),
  ];

  void _onTappedItem(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Menambahkan warna latar belakang putih
      body: _page[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Warna latar belakang navigation bar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentindex == 0
                  ? 'lib/assets/icons/tugas-after.svg'
                  : 'lib/assets/icons/tugas-before.svg',
              width: 20,
              height: 20,
            ),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentindex == 1
                  ? 'lib/assets/icons/kategori-after.svg'
                  : 'lib/assets/icons/kategori-before.svg',
              width: 20,
              height: 20,
            ),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _currentindex == 2
                  ? 'lib/assets/icons/kalender-after.svg'
                  : 'lib/assets/icons/kalender-before.svg',
              width: 20,
              height: 20,
            ),
            label: 'Kalender',
          ),
        ],
        currentIndex: _currentindex,
        selectedItemColor: AppColors.vibrantViolet,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: AppTextStyles.subhead1Regular,
        unselectedLabelStyle: AppTextStyles.subhead1Regular,
        onTap: _onTappedItem,
      ),
    );
  }
}

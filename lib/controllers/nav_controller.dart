import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // Reactive variable untuk menyimpan index tab yang aktif
  var currentIndex = 0.obs; // Menggunakan .obs untuk reaktif

  // Method untuk mengubah index
  void updateIndex(int index) {
    currentIndex.value = index;
  }
}

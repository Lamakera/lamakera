import 'package:flutter/material.dart';


class KalenderPage extends StatelessWidget {
  const KalenderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text('Halaman kalender', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

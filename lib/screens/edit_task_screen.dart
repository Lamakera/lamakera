import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lamakera/styles/colors.dart';
import 'package:lamakera/styles/fonts.dart';
import 'package:lamakera/helper/db_helper.dart'; // Import DatabaseHelper

class EditTugasPage extends StatefulWidget {
  final Map<String, dynamic> task;

  const EditTugasPage({super.key, required this.task});

  @override
  _EditTugasPageState createState() => _EditTugasPageState();
}

class _EditTugasPageState extends State<EditTugasPage> {
  late String selectedCategory;
  late bool isNotificationEnabled;
  DateTime? _selectedDate;

  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Menyiapkan data dari task yang diteruskan
    selectedCategory = widget.task['category'];
    isNotificationEnabled = widget.task['notification'] == 1;
    _selectedDate = DateTime.parse(widget.task['deadline']);
    _taskController.text = widget.task['todoText'];
  }

  String getFormattedDate(DateTime? date) {
    if (date == null) return 'Pilih Tanggal';
    return '${date.day}/${date.month}/${date.year}';
  }

  void saveTask() async {
    if (_selectedDate == null ||
        selectedCategory == 'Pilih kategori' ||
        _taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data!')),
      );
      return;
    }

    // Buat objek tugas baru
    final updatedTask = {
      'id': widget.task['id'], // Jangan lupa menyertakan ID untuk update
      'todoText': _taskController.text,
      'deadline': getFormattedDate(_selectedDate),
      'category': selectedCategory,
      'notification': isNotificationEnabled ? 1 : 0,
      'isDone': widget.task['isDone'],
    };

    // Update ke database
    await DatabaseHelper().update(updatedTask);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tugas berhasil diperbarui!')),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Tugas',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.mediumPurple,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: AppColors.mediumPurple,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.lavenderBlush,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Deadline
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Deadline',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.mediumPurple,
                                ),
                              ),
                              TextField(
                                controller: TextEditingController(
                                  text: getFormattedDate(_selectedDate),
                                ),
                                style: AppTextStyles.subhead1Regular.copyWith(
                                  color: AppColors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Pilih Tanggal',
                                  hintStyle:
                                      AppTextStyles.subhead1Regular.copyWith(
                                    color: AppColors.black,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'lib/assets/icons/iconcalender.svg',
                                      width: 22,
                                      height: 22,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      _selectedDate = selectedDate;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        // Tugas
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tugas',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.mediumPurple,
                                ),
                              ),
                              TextField(
                                controller: _taskController,
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Tuliskan Tugasmu Di Sini',
                                  hintStyle: AppTextStyles.h4.copyWith(
                                    color: AppColors.black,
                                  ),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Kategori
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kategori',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.mediumPurple,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: selectedCategory,
                                decoration: InputDecoration(
                                  hintText: 'Pilih kategori',
                                  hintStyle:
                                      AppTextStyles.subhead1Regular.copyWith(
                                    color: AppColors.black,
                                  ),
                                  border: UnderlineInputBorder(),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    child: Text(
                                      'Pilih kategori',
                                      style: AppTextStyles.subhead1Regular
                                          .copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    value: 'Pilih kategori',
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      'Kuliah',
                                      style: AppTextStyles.subhead1Regular
                                          .copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    value: 'Kuliah',
                                  ),
                                  DropdownMenuItem(
                                    child: Text(
                                      'Kerja',
                                      style: AppTextStyles.subhead1Regular
                                          .copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    value: 'Kerja',
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedCategory = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // Notifikasi
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notifikasi',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.mediumPurple,
                                ),
                              ),
                              SwitchListTile(
                                title: Text(
                                  'Nyalakan notifikasi',
                                  style: AppTextStyles.h4.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                                value: isNotificationEnabled,
                                onChanged: (bool value) {
                                  setState(() {
                                    isNotificationEnabled = value;
                                  });
                                },
                                activeColor: AppColors.vibrantViolet,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Simpan di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vibrantViolet,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Simpan Tugas',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

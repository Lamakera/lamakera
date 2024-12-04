import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lamakera/styles/fonts.dart';
import 'package:lamakera/styles/colors.dart';
import 'package:lamakera/helper/db_helper.dart';
import '../model/todo.dart';
import '../widget/todo_item.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  _KalenderPageState createState() => _KalenderPageState();
}

class _KalenderPageState extends State<KalenderPage> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  List<Map<String, dynamic>> taskList = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final data = await _databaseHelper.queryAllRows();
    setState(() {
      taskList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter tugas berdasarkan tanggal yang dipilih
    List<Map<String, dynamic>> filteredTasks = taskList.where((task) {
      DateTime deadline = DateTime.parse(task['deadline']);
      return deadline.year == _selectedDay.year &&
          deadline.month == _selectedDay.month &&
          deadline.day == _selectedDay.day;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Kalender',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.mediumPurple,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.lavenderBlush, // Warna latar belakang merah
                borderRadius: BorderRadius.circular(12), // Sudut melengkung
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Warna shadow dengan transparansi
                    blurRadius: 8, // Tingkat blur dari shadow
                    offset: Offset(0, 4), // Posisi shadow (x, y)
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchTasks(); // Update tasks when the selected day changes
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.mediumPurple,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.mediumPurple,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false, // Menyembunyikan format button
                  titleCentered: true, // Memastikan title ada di tengah
                  leftChevronVisible:
                      false, // Menyembunyikan tombol chevron kiri
                  rightChevronVisible:
                      false, // Menyembunyikan tombol chevron kanan
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Tanggal Terpilih: ${_selectedDay.toLocal()}'.split(' ')[0],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.mediumPurple,
              ),
            ),
            SizedBox(height: 20),
            // Menampilkan todo yang sesuai dengan tanggal yang dipilih
            filteredTasks.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = ToDo.fromMap(filteredTasks[index]);
                        return ToDoItem(
                          todo: task,
                          onToDoChanged: (updatedTask) async {
                            await _databaseHelper.update(updatedTask.toMap());
                            _fetchTasks();
                          },
                          onDeleteItem: (id) async {
                            await _databaseHelper.delete(id);
                            _fetchTasks();
                          },
                        );
                      },
                    ),
                  )
                : Text('Tidak ada tugas untuk tanggal ini.'),
          ],
        ),
      ),
    );
  }
}

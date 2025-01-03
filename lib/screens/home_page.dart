import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lamakera/services/theme_services.dart';
import 'package:lamakera/screens/add_task_screen.dart';
// import 'package:lamakera/widgets/button.dart';
import 'package:lamakera/widgets/task_tile.dart';
import 'package:lamakera/controllers/task_controller.dart';
import '../../models/task.dart';
import '../../services/notification_services.dart';
import 'package:lamakera/assets/size_config.dart';
import 'package:lamakera/assets/theme.dart';
import 'package:lamakera/screens/edit_task_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _customAppBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  // AppBar _customAppBar() {
  //   return AppBar(
  //     elevation: 0,
  //     backgroundColor: context.theme.scaffoldBackgroundColor,
  //     actions: [
  //       IconButton(
  //         icon: Icon(Icons.delete,
  //             size: 24, color: Get.isDarkMode ? Colors.white : darkGreyClr),
  //         onPressed: () {
  //           notifyHelper.cancelAllNotifications();
  //           _taskController.deleteAllTasks();
  //         },
  //       ),
  //       const SizedBox(width: 10), // Add spacing between icons
  //       IconButton(
  //         onPressed: () {
  //           ThemeServices().switchTheme();
  //         },
  //         icon: Icon(
  //           Get.isDarkMode
  //               ? Icons.wb_sunny_outlined
  //               : Icons.nightlight_round_outlined,
  //           size: 24,
  //           color: Get.isDarkMode ? Colors.white : darkGreyClr,
  //         ),
  //       ),
  //       const SizedBox(width: 20),
  //     ],
  //     centerTitle: true,
  //   );
  // }
  AppBar _customAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      title: Text(
        "Selamat Datang",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red
                  .withOpacity(0.2), // Latar belakang merah transparan
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.delete,
                size: 24,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
              onPressed: () {
                notifyHelper.cancelAllNotifications();
                _taskController.deleteAllTasks();
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          // padding: const EdgeInsets.symmetric(horizontal: ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue
                  .withOpacity(0.2), // Latar belakang biru transparan
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Get.isDarkMode
                    ? Icons.wb_sunny_outlined
                    : Icons.nightlight_round_outlined,
                size: 24,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
              onPressed: () {
                ThemeServices().switchTheme();
              },
            ),
          ),
        ),
        // const SizedBox(width: 10),
      ],
      // centerTitle: true,
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hari Ini',
                style: subHeadingStyle,
              ),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
            ],
          ),
          // MyButton(
          //     label: "+",
          //     onTap: () async {
          //       await Get.to(() => const AddTaskPage());
          //       _taskController.getTasks();
          //     }),
          GestureDetector(
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTasks();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: primaryClr,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        dayTextStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.poppins(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        List<Task> filteredTasks = _taskController.taskList.where((task) {
          return task.repeat == 'Daily' ||
              task.date == DateFormat.yMd().format(_selectedDate) ||
              (task.repeat == 'Weekly' &&
                  _selectedDate
                              .difference(DateFormat.yMd().parse(task.date!))
                              .inDays %
                          7 ==
                      0) ||
              (task.repeat == 'Monthly' &&
                  DateFormat.yMd().parse(task.date!).day == _selectedDate.day);
        }).toList();

        if (filteredTasks.isEmpty) {
          return _noTaskMsg(); // No tasks found
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = filteredTasks[index];
                try {
                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);

                  notifyHelper.scheduledNotification(
                    int.parse(myTime.toString().split(':')[0]),
                    int.parse(myTime.toString().split(':')[1]),
                    task,
                  );
                } catch (e) {
                  print('Error parsing time: $e');
                }

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1375),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context, task),
                        child: TaskTile(task),
                      ),
                    ),
                  ),
                );
              },
              itemCount: filteredTasks.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 200,
                    width: 200,
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'Kamu belum memiliki tugas!',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.7
                : SizeConfig.screenHeight * 0.9)
            : (task.isCompleted == 1
                ? SizeConfig.screenHeight * 0.4
                : SizeConfig.screenHeight * 0.5),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            task.isCompleted == 1
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: _buildBottomSheet(
                      label: 'Tugas Selesai',
                      onTap: () {
                        NotifyHelper().cancelNotification(task);
                        _taskController.markTaskAsCompleted(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _buildBottomSheet(
                  label: 'Edit Tugas',
                  onTap: () {
                    Get.to(() => EditTaskPage(task: task));
                  },
                  clr: primaryClr),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _buildBottomSheet(
                  label: 'Hapus Tugas',
                  onTap: () {
                    NotifyHelper().cancelNotification(task);
                    _taskController.deleteTasks(task);
                    Get.back();
                  },
                  clr: Colors.red[300]!),
            ),
            Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: _buildBottomSheet(
                  label: 'Batal',
                  onTap: () {
                    Get.back();
                  },
                  clr: primaryClr),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
    BorderRadius? borderRadius, // Tambahkan parameter untuk borderRadius
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: borderRadius ??
              BorderRadius.circular(40), // Gunakan default jika null
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

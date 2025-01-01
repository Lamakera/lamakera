import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lamakera/controllers/task_controller.dart';
import 'package:lamakera/models/task.dart';
import 'package:lamakera/widgets/button.dart';
import 'package:lamakera/widgets/input_field.dart';
import 'package:lamakera/assets/theme.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TaskController _taskController = Get.find<TaskController>();

  late TextEditingController _titleController;
  late TextEditingController _noteController;

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = DateFormat("hh:mm a")
      .format(DateTime.now().add(const Duration(hours: 1)))
      .toString();
  int _selectedRemind = 5;
  String _selectedRepeat = "None";
  int _selectedColor = 0;
  String _selectedCategory = "";

  @override
  void initState() {
    super.initState();
    _initializeTaskData();
  }

  void _initializeTaskData() {
    _titleController = TextEditingController(text: widget.task.title);
    _noteController = TextEditingController(text: widget.task.note);
    _selectedDate = DateFormat.yMd().parse(widget.task.date!);
    _startTime = widget.task.startTime!;
    _endTime = widget.task.endTime!;
    _selectedColor = widget.task.color ?? 0;
    _selectedRemind = widget.task.remind ?? 5;
    _selectedRepeat = widget.task.repeat ?? "None";
    _selectedCategory = widget.task.category ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Edit Task", style: headingStyle),
              InputField(
                title: "Title",
                hint: "Enter task title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter task note",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined),
                  onPressed: _pickDate,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded),
                        onPressed: () => _pickTime(isStartTime: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded),
                        onPressed: () => _pickTime(isStartTime: false),
                      ),
                    ),
                  ),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: [5, 10, 15, 20]
                      .map<DropdownMenuItem<String>>(
                          (int value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              ))
                      .toList(),
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items: ["None", "Daily", "Weekly", "Monthly"]
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                ),
              ),
              InputField(
                title: "Category",
                hint: _selectedCategory.isEmpty
                    ? "Select Category"
                    : _selectedCategory,
                widget: DropdownButton(
                  icon:
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: [
                    "none",
                    "Kerja",
                    "Kuliah",
                  ]
                      .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPalette(),
                  MyButton(label: "Update Task", onTap: _updateTask),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back,
            color: Get.isDarkMode ? Colors.white : darkGreyClr),
      ),
      actions: const [
        CircleAvatar(backgroundImage: AssetImage("images/profile.png")),
        SizedBox(width: 20),
      ],
    );
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                            ? pinkClr
                            : orangeClr,
                    child: _selectedColor == index
                        ? const Icon(Icons.done, color: Colors.white, size: 16)
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(hours: 1))),
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);
      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }

  void _updateTask() {
    Task updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      isCompleted: widget.task.isCompleted,
      category: _selectedCategory, 
    );

    _taskController.updateTask(updatedTask);
    Get.back();
  }
}

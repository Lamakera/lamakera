import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/todo.dart';
import 'package:lamakera/styles/fonts.dart';
import 'package:lamakera/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:lamakera/screens/edit_task_screen.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final Function(ToDo) onToDoChanged;
  final Function(int) onDeleteItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTugasPage(todo: todo),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: todo.isDone ? Colors.grey[200] : AppColors.lavenderBlush,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Custom Checkbox with White Circle
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  onToDoChanged(todo);
                },
                child: Container(
                  width: 50, // Ukuran lingkaran luar (putih)
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // Lingkaran luar berwarna putih
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 20, // Ukuran checkbox di dalam lingkaran
                      height: 20,
                      decoration: BoxDecoration(
                        color: todo.isDone
                            ? AppColors.vibrantViolet
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.vibrantViolet,
                          width: 2,
                        ),
                      ),
                      child: todo.isDone
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('EEEE, dd MMMM').format(
                            DateFormat('yyyy-MM-dd').parse(todo.deadline)),
                        style: AppTextStyles.subhead1Regular.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    todo.todoText,
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (todo.isDone)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 40, // Ukuran lingkaran
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna lingkaran
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'lib/assets/icons/cancel.svg',
                      width: 22,
                      height: 22,
                    ),
                    onPressed: () => onDeleteItem(todo.id!),
                    color: Colors.red, // Warna ikon
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../model/todo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lamakera/styles/fonts.dart';
import 'package:lamakera/styles/colors.dart';
import 'package:intl/intl.dart';

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
        onToDoChanged(todo);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: todo.isDone ? Colors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Custom Checkbox
            GestureDetector(
              onTap: () {
                onToDoChanged(todo);
              },
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: todo.isDone ? Colors.grey : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: todo.isDone
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.todoText,
                    style: AppTextStyles.subhead1Regular.copyWith(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                      color:
                          todo.isDone ? AppColors.vibrantViolet : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!todo.isDone)
                    Text(
                      DateFormat('EEEE, dd-MM-yyyy').format(
                          DateFormat('yyyy-MM-dd').parse(todo.deadline)),
                      style: AppTextStyles.paragraph2Light.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                ],
              ),
            ),
            if (todo.isDone)
              Padding(
                padding: const EdgeInsets.only(left: 1.0),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'lib/assets/icons/cancel.svg',
                    width: 22,
                    height: 22,
                  ),
                  onPressed: () => onDeleteItem(todo.id!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

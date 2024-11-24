import 'package:flutter/material.dart';
import '../model/todo.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lamakera/styles/colors.dart';

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
        onToDoChanged(todo); // Mengubah status todo saat di-tap
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
          crossAxisAlignment:
              CrossAxisAlignment.center, // Menjaga elemen tetap sejajar
          children: [
            // Custom Checkbox
            GestureDetector(
              onTap: () {
                onToDoChanged(todo); // Mengubah status saat di-tap
              },
              child: Container(
                width: 30, // Ukuran tetap untuk checkbox
                height: 30, // Ukuran tetap untuk checkbox
                decoration: BoxDecoration(
                  color: todo.isDone ? Colors.grey : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: todo.isDone
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18, // Ukuran centang
                      )
                    : null, // Tidak ada centang jika belum dicentang
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                todo.todoText,
                style: TextStyle(
                  decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: todo.isDone
                      ? AppColors.vibrantViolet
                      : AppColors.vibrantViolet, // Warna teks tetap sama
                ),
              ),
            ),
            // Menampilkan icon hapus jika todo sudah selesai
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

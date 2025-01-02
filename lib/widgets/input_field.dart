import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lamakera/assets/size_config.dart';
import 'package:lamakera/assets/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle.copyWith(
              color: primaryClr, // Ubah warna judul
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), // Rounded corner
              border: Border.all(
                color: Colors.blueAccent, // Warna border lebih menarik
                width: 1.5,
              ),
              color: Colors.white, // Background putih
              boxShadow: [
                BoxShadow(
                  color: primaryClr.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 4), // Efek shadow bawah
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    readOnly: widget != null ? true : false,
                    style: subTitleStyle.copyWith(
                      color: Colors.black, // Warna teks input
                    ),
                    cursorColor: Colors.blueAccent, // Warna kursor
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle.copyWith(
                        color: Colors.grey, // Warna hint teks
                      ),
                      border: InputBorder.none, // Hilangkan garis bawah default
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

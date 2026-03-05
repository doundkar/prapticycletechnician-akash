import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String? text;
  double textSize;
  FontWeight? textWeight;
  Color? textColor;
  Color? bgColor;
  double? radius;
  double? height;
  List<BoxShadow>? shadow;
  bool? isLoading;

  CustomButton({
    super.key,
    required this.text,
    required this.textSize,
    required this.textWeight,
    required this.textColor,
    required this.bgColor,
    required this.radius,
    required this.height,
    this.isLoading = false,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        boxShadow: shadow,
        color: bgColor,
      ),
      child: isLoading!
          ? SizedBox(height: 25,width: 25,child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(
              "$text",
              style: TextStyle(
                color: textColor,
                fontSize: textSize,
                fontWeight: textWeight,
              ),
            ),
    );
  }
}

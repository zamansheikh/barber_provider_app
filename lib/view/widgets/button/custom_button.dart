import 'package:barbar_provider/utils/app_colors.dart';
import 'package:barbar_provider/view/widgets/custom_text/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String titleText;
  final Color titleColor;
  final Color buttonColor;
  final double titleSize;
  final FontWeight titleWeight;
  final double buttonRadius;
  final double buttonHeight;
  final double? buttonWidth;
  final double left;
  final double right;
  final double top;
  final double bottom;

  final TextAlign textAlign;
  final Color borderColor;

  const CustomButton(
      {this.textAlign = TextAlign.center,
      this.onPressed,
      this.borderColor = Colors.transparent,
      required this.titleText,
      this.titleColor = AppColors.white,
      this.buttonColor = AppColors.primaryOrange,
      this.titleSize = 18,
      this.buttonRadius = 8,
      this.titleWeight = FontWeight.w600,
      this.buttonHeight = 56,
      this.buttonWidth = double.maxFinite,
      super.key,
      this.left = 0,
      this.right = 0,
      this.top = 0,
      this.bottom = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(buttonColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonRadius),
                side: BorderSide(
                    color: borderColor, width: 1, style: BorderStyle.solid)),
          ),
          elevation: WidgetStateProperty.all(0),
        ),
        child: CustomText(
          left: left,
          right: right,
          top: top,
          bottom: bottom,
          text: titleText,
          textAlign: textAlign,
          color: titleColor,
          fontWeight: titleWeight,
          fontSize: titleSize,
        ),
      ),
    );
  }
}

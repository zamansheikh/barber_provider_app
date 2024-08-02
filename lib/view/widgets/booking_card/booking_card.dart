import 'package:barbar_provider/helper/network_image.dart';
import 'package:barbar_provider/service/api_url.dart';
import 'package:barbar_provider/utils/app_colors.dart';
import 'package:barbar_provider/view/widgets/button/custom_button.dart';
import 'package:barbar_provider/view/widgets/custom_text/custom_text.dart';
import 'package:barbar_provider/view/widgets/row_text/row_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BookingCard extends StatelessWidget {
  const BookingCard(
      {super.key,
      required this.profileImage,
      required this.profileName,
      required this.date,
      required this.catelouges,
      required this.totalPrice,
      this.onTap,
      this.onPressedLeft,
      this.onPressedRight,
      required this.buttonLeft,
      required this.buttonRight,
      required this.time});

  final String profileImage;
  final String profileName;
  final String date;
  final String time;

  final List<dynamic>? catelouges;
  final String totalPrice;
  final String buttonLeft;
  final String buttonRight;
  final VoidCallback? onTap;
  final VoidCallback? onPressedLeft;
  final VoidCallback? onPressedRight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: AppColors.primaryOrange,
                width: 1,
                style: BorderStyle.solid),
            color: AppColors.cardBgColor),
        child: Column(
          children: [
            Row(
              children: [
                //==============================Image=============================

                CustomNetworkImage(
                    boxShape: BoxShape.circle,
                    imageUrl: "${ApiConstant.baseUrl}$profileImage",
                    height: 64.h,
                    width: 64.w),

                //=================================Name==============================

                Flexible(
                  child: CustomText(
                      text: profileName,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      left: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            //=================================date==============================

            RowText(field: "Date:".tr, value: date),
            const SizedBox(height: 12),

            //=================================Catelouge==============================

            Row(
              children: [
                const CustomText(
                  fontSize: 14,
                  text: "Catelouge :",
                ),
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    children: List.generate(catelouges!.length, (index) {
                      return CustomText(
                        maxLines: 100,
                        fontSize: 12.w,
                        fontWeight: FontWeight.w500,
                        right: 0,
                        text: "${catelouges![index].catalogName ?? ""} ",
                      );
                    }),
                  ),
                )
              ],
            ),

            // RowText(field: "Services :".tr, value: catelouges, maxLine: 2),
            const SizedBox(height: 12),

            //=================================Total Amount==============================

            RowText(field: "Total Amount :".tr, value: "\$ $totalPrice"),
            const SizedBox(height: 16),

            RowText(field: "Time :".tr, value: time),
            const SizedBox(height: 16),

            Row(
              children: [
                //=================================Accept Button===========================

                Expanded(
                    child: CustomButton(
                        titleText: buttonLeft,
                        buttonHeight: 44,
                        titleSize: 12,
                        onPressed: onPressedLeft)),
                const SizedBox(width: 12),

                //=================================Decline Button===========================

                Expanded(
                  child: CustomButton(
                    titleSize: 12,
                    onPressed: onPressedRight,
                    titleText: buttonRight,
                    buttonHeight: 44,
                    buttonColor: AppColors.cardBgColor,
                    borderColor: AppColors.primaryOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:barbar_provider/utils/app_colors.dart';
import 'package:barbar_provider/utils/app_constent.dart';
import 'package:barbar_provider/utils/snack_bar.dart';
import 'package:barbar_provider/view/screens/approved_booking/controller/approved_booking_controller.dart';
import 'package:barbar_provider/view/screens/booking_request/controller/booking_reqcontroller.dart';
import 'package:barbar_provider/view/screens/no_internet/no_internet.dart';
import 'package:barbar_provider/view/widgets/appbar/custom_appbar.dart';
import 'package:barbar_provider/view/widgets/back/custom_back.dart';
import 'package:barbar_provider/view/widgets/booking_card/booking_card.dart';
import 'package:barbar_provider/view/widgets/custom_loader/custom_loader.dart';
import 'package:barbar_provider/view/widgets/custom_text/custom_text.dart';
import 'package:barbar_provider/view/widgets/error/general_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ApprovedBooking extends StatelessWidget {
  ApprovedBooking({super.key});

  final ApprovedBookingController approvedBookingController =
      Get.find<ApprovedBookingController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
            backgroundColor: AppColors.bgColor,
            extendBody: true,
            appBar: CustomAppBar(
                appBarContent: CustomBack(text: "Approved Bookings".tr)),
            body: Obx(() {
              switch (approvedBookingController.rxRequestStatus.value) {
                case Status.loading:
                  return const CustomLoader();
                case Status.internetError:
                  return NoInternetScreen(
                    onTap: () {
                      approvedBookingController.approvedBooking();
                    },
                  );
                case Status.error:
                  return GeneralErrorScreen(
                    onTap: () {
                      approvedBookingController.refreshApprovedBooking();
                    },
                  );

                case Status.completed:
                  return approvedBookingController.approvedBookingModel.isEmpty
                      ? Center(
                          child: CustomText(
                            fontSize: 18.sp,
                            text: "No booking approved yet",
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            approvedBookingController.approvedBooking();
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                                top: 24.h, right: 20.w, left: 20.w),
                            controller:
                                approvedBookingController.scrollController,
                            itemCount: approvedBookingController
                                .approvedBookingModel.length,
                            itemBuilder: (context, index) {
                              var data = approvedBookingController
                                  .approvedBookingModel[index].booking;

                              if (approvedBookingController
                                      .isLoadMoreRunning.value ==
                                  false) {
                                return BookingCard(
                                  profileImage: data!.user!.image ?? "",
                                  profileName: data.user!.name ?? "",
                                  date: data.date ?? "",
                                  catelouges: approvedBookingController
                                      .approvedBookingModel[index]
                                      .catalogDetails,
                                  totalPrice: data.price ?? "",
                                  buttonLeft: "Complete".tr,
                                  buttonRight: "Mark as late".tr,
                                  time: data.time ?? "",

                                  //================================Complete Button=========================

                                  onPressedLeft: () {
                                    final BookingRequestController
                                        bookingRequestController =
                                        Get.find<BookingRequestController>();
                                    if (data.status == 6) {
                                      bookingRequestController.updateBooking(
                                          bookingID: approvedBookingController
                                              .approvedBookingModel[index]
                                              .booking!
                                              .id
                                              .toString(),
                                          updateBooking:
                                              UpdateBooking.complete);
                                    } else {
                                      toastMessage(
                                          message: "Service not ended yet");
                                    }
                                  },
                                  //================================Complete Button=========================

                                  onPressedRight: () {
                                    final BookingRequestController
                                        bookingRequestController =
                                        Get.find<BookingRequestController>();
                                    bookingRequestController.updateBooking(
                                        bookingID: approvedBookingController
                                            .approvedBookingModel[index]
                                            .booking!
                                            .id
                                            .toString(),
                                        updateBooking: UpdateBooking.late);
                                  },
                                );
                              } else {
                                return const CustomLoader();
                              }
                            },
                          ),
                        );
              }
            })));
  }
}

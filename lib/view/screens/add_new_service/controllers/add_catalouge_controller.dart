import 'dart:convert';
import 'dart:io';
import 'package:barbar_provider/core/app_route/app_route.dart';
import 'package:barbar_provider/helper/time_converter.dart';
import 'package:barbar_provider/service/api_ckeck.dart';
import 'package:barbar_provider/service/api_url.dart';
import 'package:barbar_provider/service/app_service.dart';
import 'package:barbar_provider/utils/snack_bar.dart';
import 'package:barbar_provider/view/screens/catalouge_list/controller/catalouge_list_controller.dart';
import 'package:barbar_provider/view/screens/catalouge_list/model/catalouge_list_model.dart';
import 'package:barbar_provider/view/screens/home/controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddCatalougeController extends GetxController {
  List<Map<String, dynamic>> days = [
    {"day": "Sun", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Mon", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Tue", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Wed", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Thu", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Fri", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Sat", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
  ];
  HomeController homeController = Get.find<HomeController>();

  CatalougeListController catalougeListController =
      Get.find<CatalougeListController>();

  TextEditingController serviceNameController =
      TextEditingController(text: kDebugMode ? "Hair Cut" : "");

  TextEditingController serviceDesController = TextEditingController(
      text: kDebugMode
          ? "Moye Moye Salon, Very Cheap. The place you get your hair cut. A salon is a good place to get a perm or highlights, to get your nails painted, or just to get a trim. A salon is like a barber shop, only fancier"
          : "");

  TextEditingController serviceDurationController =
      TextEditingController(text: kDebugMode ? "1" : "");

  TextEditingController salonSerChargeController =
      TextEditingController(text: kDebugMode ? "1" : "");

  TextEditingController homeSerChargeController =
      TextEditingController(text: kDebugMode ? "1" : "");

  TextEditingController setBookingController =
      TextEditingController(text: kDebugMode ? "1" : "");

  List<Map<String, dynamic>> selectedServiceHours = [];

  File? galleryPhoto;

  bool isLoading = false;

  //============================Open the Gallary to pick image========================

  void openGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 15);

    if (pickedFile != null) {
      galleryPhoto = File(pickedFile.path);
      debugPrint("Gallery Photo======================$galleryPhoto");
    }
    update();
  }

  //============================Get the Service Time========================

  getServiceTime() {
    //======================Getting the Json of Date======================
    for (var data in days) {
      selectedServiceHours.add({
        "Day": data["day"],
        "Start Time": formatTimeOfDay(data["start"]),
        "End Time": formatTimeOfDay(data["end"]),
      });
    }
    debugPrint("Service Time===================>>>>>>>$selectedServiceHours");
    update();
  }

  //=====================================Add Catalouge================================

  addCatalouge({required String serviceID}) async {
    isLoading = true;
    getServiceTime();
    update();

    if (galleryPhoto != null) {
      var body = {
        "serviceId": serviceID,
        "catalougName": serviceNameController.text,
        "description": serviceDesController.text,
        "serviceDuration": serviceDurationController.text,
        "serviceCharge": salonSerChargeController.text,
        "bookingMoney": setBookingController.text,
        "serviceHoure": jsonEncode(selectedServiceHours),
        "homeServiceCharge": homeSerChargeController.text,
      };

      var response = await ApiClient.postMultipartData(
          ApiConstant.postCatalouge, body,
          multipartBody: [
            MultipartBody("catalougPhoto[]", galleryPhoto!),
          ]);

      if (response.statusCode == 200) {
        homeController.homeData();
        catalougeListController.getCatalougeList(serviceID: serviceID);
        debugPrint("serviceId========================$serviceID");
        debugPrint(
            "selectedServiceHours========================$selectedServiceHours");
        Get.offAllNamed(AppRoute.navBar);
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      showCustomSnackBar("Pick image");
    }

    isLoading = false;
    update();
  }

  //=====================================Update Catalouge================================

  updateCatalouge(
      {required Provider catelougeInfo,
      required List<Map<String, dynamic>> updatedServiceHours}) async {
    isLoading = true;
    getServiceTime();
    update();

    var body = {
      "id": catelougeInfo.id.toString(),
      "providerId": catelougeInfo.providerId.toString(),
      "serviceId": catelougeInfo.serviceId.toString(),
      "catalougName": serviceNameController.text,
      "description": serviceDesController.text,
      "serviceDuration": serviceDurationController.text,
      "serviceCharge": salonSerChargeController.text,
      "bookingMoney": setBookingController.text,
      "serviceHoure":
          jsonEncode(timeDateToString(response: updatedServiceHours)),
      "homeServiceCharge": homeSerChargeController.text,
    };

    var response = galleryPhoto != null
        ? await ApiClient.postMultipartData(ApiConstant.updateCatalouge, body,
            multipartBody: [
                MultipartBody("catalougPhoto[]", galleryPhoto!),
              ])
        : await ApiClient.postData(ApiConstant.updateCatalouge, body);

    if (response.statusCode == 200) {
      catalougeListController.getCatalougeList(
          serviceID: catelougeInfo.serviceId.toString());
      navigator!.pop();
      navigator!.pop();
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
}

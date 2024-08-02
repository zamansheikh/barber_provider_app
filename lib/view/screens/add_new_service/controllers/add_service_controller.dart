import 'dart:convert';
import 'dart:io';

import 'package:barbar_provider/core/app_route/app_route.dart';
import 'package:barbar_provider/helper/prefs_helper.dart';
import 'package:barbar_provider/helper/time_converter.dart';
import 'package:barbar_provider/service/api_ckeck.dart';
import 'package:barbar_provider/service/api_url.dart';
import 'package:barbar_provider/service/app_service.dart';
import 'package:barbar_provider/utils/app_constent.dart';
import 'package:barbar_provider/utils/snack_bar.dart';
import 'package:barbar_provider/view/screens/home/controller/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddServiceController extends GetxController {
  List<Map<String, dynamic>> days = [
    {"day": "Sun", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Mon", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Tue", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Wed", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Thu", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Fri", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
    {"day": "Sat", "start": TimeOfDay.now(), "end": TimeOfDay.now()},
  ];

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

  File? pickGalleryPhoto;

  bool isLoading = false;

  HomeController homeController = Get.find<HomeController>();
  //=================================Open Gallary for image==============================

  void openGallery() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 15);

    if (pickedFile != null) {
      pickGalleryPhoto = File(pickedFile.path);
      debugPrint("Gallery Photo======================$pickGalleryPhoto");
    }
    update();
  }

//=================================Get the Service hour Details==============================
  getServiceTime() {
    //======================Getting the Json of Date======================
    for (var data in days) {
      selectedServiceHours.add({
        "Day": data["day"],
        "Start Time": formatTimeOfDay(data["start"]),
        "End Time": formatTimeOfDay(data["end"]),
      });
    }
    debugPrint(
        "Service Time===================>>>>>>>${jsonEncode(selectedServiceHours)}");
    update();
  }

  //=================================Add Service==============================

  addService() async {
    isLoading = true;
    getServiceTime();
    //=======================Get Catagory ID=====================

    String catIDShaPre = await SharePrefsHelper.getString(AppConstants.catID);
    String providerID =
        await SharePrefsHelper.getString(AppConstants.providerID);

    debugPrint("=====================$providerID===========================");
    debugPrint("catIDShaPre========================$catIDShaPre");
    debugPrint(
        "selectedServiceHours========================${jsonEncode(selectedServiceHours)}");

    update();

    if (pickGalleryPhoto != null) {
      var body = {
        "catId": catIDShaPre,
        "serviceName": serviceNameController.text,
        "description": serviceDesController.text,
        "serviceOur": serviceDurationController.text,
        "serviceCharge": salonSerChargeController.text,
        "homServiceCharge": homeSerChargeController.text,
        "bookingMony": setBookingController.text,
        "serviceHour": jsonEncode(selectedServiceHours),
        "providerid": providerID
      };

      var response = await ApiClient.postMultipartData(
          ApiConstant.postService, body,
          multipartBody: [
            MultipartBody("servicePhotoGellary[]", pickGalleryPhoto!),
          ]);

      if (response.statusCode == 200) {
        debugPrint("catIDShaPre========================$catIDShaPre");
        debugPrint(
            "selectedServiceHours========================$selectedServiceHours");
        var jSON = jsonDecode(response.body);

        Get.offNamed(AppRoute.addCatalouge, arguments: jSON["data"]["id"]);
        homeController.homeData();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      showCustomSnackBar("Pick image");
    }

    isLoading = false;
    update();
  }

  //=================================Update Service==============================

  updateService(
      {required String serviceID,
      required List<Map<String, dynamic>> updatedServiceHours}) async {
    isLoading = true;

    //==================================Get CatID and Provider ID===============================

    String catIDShaPre = await SharePrefsHelper.getString(AppConstants.catID);
    String providerID =
        await SharePrefsHelper.getString(AppConstants.providerID);

    update();

    var body = {
      "id": serviceID,
      "catId": catIDShaPre,
      "serviceName": serviceNameController.text,
      "description": serviceDesController.text,
      "serviceOur": serviceDurationController.text,
      "serviceCharge": salonSerChargeController.text,
      "homServiceCharge": homeSerChargeController.text,
      "bookingMony": setBookingController.text,
      "serviceHour":
          jsonEncode(timeDateToString(response: updatedServiceHours)),
      "providerId": providerID
    };

    var response = pickGalleryPhoto != null
        ? await ApiClient.postMultipartData(
            multipartBody: [
              MultipartBody("servicePhotoGellary[]", pickGalleryPhoto!),
            ],
            ApiConstant.updateService,
            body,
          )
        : await ApiClient.postData(ApiConstant.updateService, body);

    if (response.statusCode == 200) {
      homeController.homeData();
      Get.offAllNamed(AppRoute.navBar);
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
}

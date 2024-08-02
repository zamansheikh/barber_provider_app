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

class AddProviderController extends GetxController {
  TextEditingController buisnessNameController =
      TextEditingController(text: kDebugMode ? "Shanto Salon" : "");
  TextEditingController addressController =
      TextEditingController(text: kDebugMode ? "Demra Stuf Quater" : "");
  TextEditingController descriptionController = TextEditingController(
      text: kDebugMode
          ? "Moye Moye Salon, Very Cheap. The place you get your hair cut. A salon is a good place to get a perm or highlights, to get your nails painted, or just to get a trim. A salon is like a barber shop, only fancier"
          : "");
  HomeController homeController = Get.find<HomeController>();
  List<Map<String, dynamic>> selectedServiceHours = [];
  File? coverPhoto;
  File? galleryPhoto;

  String catId = "";
  String providerID = "";

  bool isLoading = false;

  //=================================Open Gallary for image==============================

  void openGallery({required bool isCoverPhoto}) async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 15);

    if (pickedFile != null) {
      if (isCoverPhoto) {
        coverPhoto = File(pickedFile.path);
        debugPrint("Cover Photo======================$coverPhoto");
      } else {
        galleryPhoto = File(pickedFile.path);
        debugPrint("Gallery Photo======================$galleryPhoto");
      }
    }
    update();
  }

  //=================================Get the Service hour Details==============================

  getServiceDate({required String getCatId, required bool navigateScreen}) {
    if (navigateScreen == true) {
      Get.toNamed(AppRoute.addPhotos);
    }

    // debugPrint("Selected Service Hours=========$days");

    //======================Getting the Json of Date======================
    for (var data in serviceHours) {
      selectedServiceHours.add({
        "Day": data["day"],
        "Start Time": formatTimeOfDay(data["start"]),
        "End Time": formatTimeOfDay(data["end"]),
      });
    }

    catId = getCatId;

    update();

    debugPrint(
        "Selected Service Hours=========${jsonEncode(selectedServiceHours)}");
    debugPrint("Cat Id=========$catId");
  }

  //=================================Add Provider==============================

  addProvider() async {
    isLoading = true;
    update();

    if (coverPhoto != null && galleryPhoto != null) {
      var body = {
        "catId": catId.toString(),
        "businessName": buisnessNameController.text,
        "address": addressController.text,
        "description": descriptionController.text,
        "serviceOur": jsonEncode(selectedServiceHours),
      };

      var response = await ApiClient.postMultipartData(
          ApiConstant.addProvider, body,
          multipartBody: [
            MultipartBody("coverPhoto", coverPhoto!),
            MultipartBody("photoGellary[]", galleryPhoto!),
          ]);

      if (response.statusCode == 200) {
        homeController.homeData();

        var jSONData = jsonDecode(response.body);
        debugPrint("catIDShaPre========================$catId");

        debugPrint(
            "Provider ID========================${jSONData["data"]["id"]}");

        SharePrefsHelper.setString(AppConstants.catID, catId);
        SharePrefsHelper.setString(
            AppConstants.providerID, jSONData["data"]["id"].toString());
        SharePrefsHelper.setBool(AppConstants.isProviderAdded, true);

        Get.offAllNamed(AppRoute.addServiceDetails);
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      showCustomSnackBar("Pick image");
    }

    isLoading = false;
    update();
  }

  List<MultipartBody> photoList = [];

  //=================================Update Provider==============================

  updateProvider(
      {required List<Map<String, dynamic>> updatedServiceHours}) async {
    isLoading = true;

    String? getTheCatID = await SharePrefsHelper.getString(AppConstants.catID);
    String? getProviderID =
        await SharePrefsHelper.getString(AppConstants.providerID);

    update();

    var body = {
      "id": getProviderID,
      "catId": getTheCatID,
      "businessName": buisnessNameController.text,
      "address": addressController.text,
      "description": descriptionController.text,
      "serviceOur": jsonEncode(timeDateToString(response: updatedServiceHours)),
    };

    var response = coverPhoto != null || galleryPhoto != null
        ? await ApiClient.postMultipartData(
            multipartBody: [
              if (coverPhoto != null) MultipartBody("coverPhoto", coverPhoto!),
              if (galleryPhoto != null)
                MultipartBody("photoGellary[]", galleryPhoto!),
            ],
            ApiConstant.updateProvider,
            body,
          )
        : await ApiClient.postData(ApiConstant.updateProvider, body);

    if (response.statusCode == 200) {
      homeController.homeData();

      navigator!.pop();
    } else {
      ApiChecker.checkApi(response);
    }

    isLoading = false;
    update();
  }
}

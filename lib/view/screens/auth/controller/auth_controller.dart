import 'dart:convert';
import 'package:barbar_provider/core/app_route/app_route.dart';
import 'package:barbar_provider/core/di_service/dependency_injection.dart';
import 'package:barbar_provider/core/global/location_controller.dart';
import 'package:barbar_provider/helper/prefs_helper.dart';
import 'package:barbar_provider/service/api_ckeck.dart';
import 'package:barbar_provider/service/api_url.dart';
import 'package:barbar_provider/service/app_service.dart';
import 'package:barbar_provider/utils/app_constent.dart';
import 'package:barbar_provider/utils/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authcontroller extends GetxController {
  bool loading = false;

  LocationController locationController = Get.find<LocationController>();

  String otp = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController =
      TextEditingController(text: kDebugMode ? "vapox12663@ekposta.com" : "");
  TextEditingController passWordController =
      TextEditingController(text: kDebugMode ? "1234567rr" : "");
  TextEditingController confirmPasController = TextEditingController();

  var headers = {'Accept': 'application/json'};

//================================Sign In User==============================
  signInUser() async {
    Dependancy dI = Dependancy();
    dI.dependencies();
    loading = true;
    var headers = {'Content-Type': 'application/json'};

    update();
    Map<String, String> body = {
      'email': emailController.text,
      'password': passWordController.text,
    };

    var response = await ApiClient.postData(ApiConstant.login, jsonEncode(body),
        headers: headers);

    if (response.statusCode == 200) {
      //==========================save user info======================

      SharePrefsHelper.setBool(AppConstants.isSocialLogIn, false);

      SharePrefsHelper.setString(
          AppConstants.bearerToken, response.body["access_token"]);
      SharePrefsHelper.setString(
          AppConstants.profileID, response.body["user_id"].toString());

      Get.offNamed(
        AppRoute.navBar,
      );

      Dependancy dI = Dependancy();
      dI.dependencies();
    } else {
      ApiChecker.checkApi(response);
    }
    loading = false;
    update();
  }

//================================Sign Up User==============================

  signUpUser() async {
    loading = true;

    //===============Get latitude and longitude============

    String? latitude = await SharePrefsHelper.getString(AppConstants.latitude);
    String? longitude =
        await SharePrefsHelper.getString(AppConstants.longitude);
    update();
    Map<String, String> body = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passWordController.text,
      'password_confirmation': confirmPasController.text,
      "latitude": latitude,
      "longitude": longitude,
      "user_type": "provider",
    };

    var response =
        await ApiClient.postData(ApiConstant.register, body, headers: headers);
    if (response.statusCode == 200) {
      Get.toNamed(AppRoute.otpScreen, arguments: false);
    } else {
      ApiChecker.checkApi(response);
    }
    loading = false;
    update();
  }

//================================Sign In With Google==============================

  Future<void> signInWithGoogle() async {
    Dependancy dI = Dependancy();
    dI.dependencies();
    //==================Get Location Permission=============

    locationController.getLocation();

    //========Trigger the authentication flow=========

    final googleUser = await GoogleSignIn().signIn();

    debugPrint(
        "credential====================================================$googleUser");
    debugPrint(
        "Google User ID====================================================${googleUser!.id}");

    //================Send Information To Server==================
    loading = true;
    update();

    //===============Get latitude and longitude============

    String? latitude = await SharePrefsHelper.getString(AppConstants.latitude);
    String? longitude =
        await SharePrefsHelper.getString(AppConstants.longitude);

    var body = {
      "name": googleUser.displayName ?? "",
      "email": googleUser.email,
      "google_id": googleUser.id,
      "user_type": "provider",
      "latitude": latitude,
      "longitude": longitude,
    };

    var response = await ApiClient.postData(ApiConstant.socialAuth, body);

    if (response.statusCode == 200) {
      debugPrint(
          "Access token=================================${response.body["access_token"]}");

      SharePrefsHelper.setString(
          AppConstants.bearerToken, response.body["access_token"]);

      SharePrefsHelper.setBool(AppConstants.isSocialLogIn, true);
      loading = false;
      update();

      Get.offAllNamed(AppRoute.navBar);
    } else {
      GoogleSignIn().signOut();
      ApiChecker.checkApi(response);
      loading = false;
      update();
    }
  }

  Future<void> facebookSignIn() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Check if the user has logged in successfully
    if (loginResult.status == LoginStatus.success) {
      // Retrieve user profile data
      // final AccessToken? accessToken = loginResult.accessToken;
      final userData = await FacebookAuth.instance.getUserData();

      // Access user information
      final String userId = userData["id"];
      final String userName = userData["name"];
      // You can access other user information as well

      // Example of accessing user email if provided
      final String userEmail = userData["email"];

      // Example of accessing user phone number if provided
      final String userPhoneNumber = userData["phone"];

      // Print user information
      debugPrint("User ID: $userId");
      debugPrint("User Name: $userName");
      debugPrint("User Email: $userEmail");
      debugPrint("User Phone Number: $userPhoneNumber");

      // Now you can use this information as needed in your application
    }
  }
//================================Resend OTP==============================

  Future<bool> resendOTP() async {
    loading = true;
    update();
    var body = {
      "email": emailController.text,
    };
    var response = await ApiClient.postData(
      ApiConstant.resendOtp,
      body,
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      loading = false;
      update();
      return true;
    } else {
      ApiChecker.checkApi(response);
      loading = false;
      update();
      return false;
    }
  }

//================================Varify OTP==============================

  varifyOTP({required bool forgetPass}) async {
    loading = true;
    update();
    var body = {"email": emailController.text, "otp": otp};
    var response = await ApiClient.postData(
      ApiConstant.verified,
      body,
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      //================================Save Token================================

      SharePrefsHelper.setString(AppConstants.bearerToken,
          response.body["token"]["original"]["access_token"]);

      //================================Set if Provider added or not {default is false}================================

      SharePrefsHelper.setBool(AppConstants.isProviderAdded, false);
      //=========================Set the payment false so that user cant add Provider=====================

      if (forgetPass == false) {
        SharePrefsHelper.setBool(AppConstants.paymentDone, false);
      }

      SharePrefsHelper.setBool(AppConstants.isSocialLogIn, false);

      forgetPass == true
          ? Get.offAllNamed(AppRoute.resetPassword)
          : Get.offNamed(
              AppRoute.navBar,
            );
    } else {
      ApiChecker.checkApi(response);
    }
    loading = false;
    update();
  }

//================================Reset Password==============================

  resetPassword() async {
    loading = true;

    var bearerToken =
        await SharePrefsHelper.getString(AppConstants.bearerToken);
    update();

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    var body = {
      "password": passWordController.text,
      "password_confirmation": confirmPasController.text
    };

    var response = await ApiClient.postData(ApiConstant.resetPassword, body,
        headers: headers);

    if (response.statusCode == 200) {
      toastMessage(message: "Successfully updated");
      Get.offNamed(AppRoute.signInScreen);
    } else {
      ApiChecker.checkApi(response);
    }

    loading = false;
    update();
  }
}

import 'dart:convert';

import 'package:barbar_provider/core/app_route/app_route.dart';
import 'package:barbar_provider/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() async {
  String apiEndPoint = 'http://192.168.10.99:5002/api/v1';
  final response = await http.post(
    Uri.parse('$apiEndPoint/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': 'kafikafi1922@gmail.com',
      'password': 'kafikafi1922@gmail.com'
    }),
  );
  AppLogger.e(response.body);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 966),
        builder: (_, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.noTransition,
            transitionDuration: const Duration(milliseconds: 200),
            initialRoute: AppRoute.splashscreen,
            navigatorKey: Get.key,
            getPages: AppRoute.routes,
          );
        });
  }
}

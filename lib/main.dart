import 'package:barbar_provider/core/app_route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
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

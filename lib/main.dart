import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/firebase_options.dart';
import 'package:do_an_ck/routes/app_pages.dart';
import 'package:do_an_ck/routes/app_routes.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthController authController = Get.put(AuthController());
  await authController.checkUserLoggedIn();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Udon App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: AppColors.secondary,
            ),
          )),
      initialRoute: Get.find<AuthController>().isLogin.value
          ? (Get.find<AuthController>().userRole.value == 'admin'
              ? Routes.ADMIN
              : Routes.HOME)
          : Routes.ONBOARDING,
      getPages: AppPages.routes,
    );
  }
}

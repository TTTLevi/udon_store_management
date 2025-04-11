import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardController extends GetxController {

  final pageController = PageController();

  var currentPage = 0.obs;

  void goToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(
      () {
        if (pageController.page?.toInt() != currentPage.value) {
          currentPage.value = pageController.page?.toInt() ?? 0;
        }

        if (pageController.page == 1) {
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.toNamed('/login');
          });
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}

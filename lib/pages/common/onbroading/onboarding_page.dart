import 'package:do_an_ck/controller/onboarding/onboard_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/pages/common/onbroading/widgets/onboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardController onboardController = Get.find<OnboardController>();

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed('/login');
            },
            child: const Text('Bỏ qua',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: onboardController.pageController,
              onPageChanged: (page) {
                onboardController.currentPage.value = page;
              },
              children: const [
                
                OnboardWidget(
                  title: 'Udon, xin chào',
                  description: 'Chúc bạn làm việc vui vẻ',
                  image: 'assets/images/mi_udon1.png',
                ),
                OnboardWidget(
                  title: 'Udon, ngon ngon',
                  description: 'Tiếp thêm sức sống mỗi ngày',
                  image: 'assets/images/onboard2.png',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(21.0),
            child: SmoothPageIndicator(
              controller: onboardController.pageController,
              count: 2,
              effect: const ExpandingDotsEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: AppColors.secondary,
                dotColor: Colors.grey,
              ),
              onDotClicked: (index) {
                onboardController.goToPage(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

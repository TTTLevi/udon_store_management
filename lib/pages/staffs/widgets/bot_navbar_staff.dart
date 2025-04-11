import 'package:do_an_ck/pages/staffs/cart_page.dart';
import 'package:do_an_ck/pages/staffs/homepage.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigationStaff extends StatelessWidget {
  const BottomNavigationStaff({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(), tag: 'staff-nav', permanent: true);


    final initialIndex = Get.arguments as int? ?? 0;
    // Set the initial index after the first frame is rendered
    // This is necessary to avoid the error of trying to set the state before the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.changeIndex(initialIndex);
    });

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 65,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (value) => controller.changeIndex(value),
          backgroundColor: AppColors.bgAppbar,
          indicatorColor: Colors.yellow.shade700,
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.bag), label: 'Giỏ'),
            // NavigationDestination(
            //     icon: Icon(Iconsax.receipt_2), label: 'Orders'),
            // NavigationDestination(icon: Icon(Iconsax.user), label: 'Users'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    Homepage(),
    CartPage(),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
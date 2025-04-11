import 'package:do_an_ck/pages/admin/dashboard.dart';
import 'package:do_an_ck/pages/admin/notification.dart';
import 'package:do_an_ck/pages/admin/invoice/orderlist.dart';
import 'package:do_an_ck/pages/admin/product/product.dart';
import 'package:do_an_ck/pages/admin/user/user_view.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavigationAdmin extends StatelessWidget {
  const BottomNavigationAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController(), tag: 'admin-nav' ,permanent: true);

    final initialIndex = Get.arguments as int? ?? 0;
    controller.changeIndex(initialIndex);

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
            NavigationDestination(
                icon: Icon(Iconsax.element_equal), label: 'Tổng quan'),
            NavigationDestination(icon: Icon(Iconsax.box), label: 'Sản phẩm'),
            // NavigationDestination(
            //     icon: Icon(Iconsax.notification), label: 'Thông báo'),
            NavigationDestination(
                icon: Icon(Iconsax.receipt_2), label: 'Hóa đơn'),
            NavigationDestination(
                icon: Icon(Iconsax.user), label: 'Nhân viên'),
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
    Dashboard(),
    Product(),
    // NotificationPage(),
    Orderlist(),
    UserView(),
  ];
  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

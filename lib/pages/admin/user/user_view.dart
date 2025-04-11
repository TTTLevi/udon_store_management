import 'package:do_an_ck/controller/user/user_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserView extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber.shade50,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Danh sách nhân viên',
            style: TextStyle(color: AppColors.secondary, fontSize: 27),
          ),
          backgroundColor: AppColors.light,
        ),
        body: Obx(
          () {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userController.userList.isEmpty) {
              return const Center(child: Text('Chưa có nhân viên nào'));
            }
            return ListView.builder(
              itemCount: userController.userList.length,
              itemBuilder: (context, index) {
                final user = userController.userList[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          },
        ));
  }
}

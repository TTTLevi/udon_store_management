import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatelessWidget {
  final authController = Get.find<AuthController>();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(21),
        child: Column(
          children: [
            const Text(
              'Quên mật khẩu?',
              style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Hãy nhập email vào đây, chúng tôi sẽ gửi cho bạn link để khôi phục mật khẩu',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Nhập email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isNotEmpty){
                  authController.resetPassword(email);
                } else {
                  Get.snackbar('Lỗi', 'Vui lòng nhập email');
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.light,
                  foregroundColor: AppColors.secondary),
              child: const Text('Gửi'),
            ),
          ],
        ),
      ),
    );
  }
}

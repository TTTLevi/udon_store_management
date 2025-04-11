import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final String role = 'staff';

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Đăng ký',
            style: TextStyle(color: AppColors.secondary, fontSize: 30),
          ),
          backgroundColor: AppColors.light,
          centerTitle: true,
          iconTheme: const IconThemeData(color: AppColors.secondary)),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Image(
              image: AssetImage('assets/images/nv_mi.png'),
              height: 150,
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Họ và tên',
                        hintText: 'Nhập họ và tên',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        if (value.length < 3) {
                          return 'Họ và tên phải có ít nhất 3 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Nhập email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        return validateEmail(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => TextFormField(
                        controller: passwordController,
                        obscureText: authController.isPasswordObscure.value,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          hintText: 'Nhập mật khẩu',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                authController.togglePasswordVisibility();
                              },
                              icon: Icon(authController.isPasswordObscure.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          return validatePassword(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => TextFormField(
                        controller: confirmPasswordController,
                        obscureText:
                            authController.isConfirmPasswordObscure.value,
                        decoration: InputDecoration(
                          labelText: 'Nhập lại mật khẩu',
                          hintText: 'Nhập lại mật khẩu',
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isConfirmPasswordObscure.value
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              authController.toggleConfirmPasswordVisibility();
                            },
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập lại mật khẩu';
                          }
                          if (value != passwordController.text) {
                            return 'Mật khẩu không khớp';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Obx(
                      () => ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final emailExists =
                                      await authController.checkEmailExists(
                                          emailController.text.trim());
                                  if (emailExists) {
                                    Get.snackbar('Lỗi', 'Email đã tồn tại',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white);
                                    return;
                                  }
                                  authController.signUp(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    nameController.text.trim(),
                                    role,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.light,
                          foregroundColor: AppColors.secondary,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Đăng ký'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

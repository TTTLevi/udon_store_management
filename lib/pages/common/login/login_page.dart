import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    authController.getSavedCredentials().then((value) {
      if (value['email'] != null && value['password'] != null) {
        emailController.text = value['email']!;
        passwordController.text = value['password']!;
        authController.rememberMe.value = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đăng nhập',
          style: TextStyle(
              color: AppColors.secondary,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.light,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
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
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        return validateEmail(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => TextFormField(
                        obscureText: authController.isPasswordObscure.value,
                        controller: passwordController,
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
                                : Iconsax.eye),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() => Checkbox(
                                  value: authController.rememberMe.value,
                                  onChanged: (value) {
                                    authController.rememberMe.value = value!;
                                  },
                                )),
                            const Text('Lưu mật khẩu'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/forgot-password');
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await authController.savePassword(
                                emailController.text,
                                passwordController.text,
                                authController.rememberMe.value);
                            authController.login(
                                emailController.text, passwordController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.light,
                            foregroundColor: AppColors.secondary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: authController.isLoading.value
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text('Đăng nhập'),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản?'),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/signup');
                          },
                          child: const Text('Đăng ký ngay',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Flexible(
                    //         child: Divider(
                    //       color: Colors.black,
                    //       thickness: 0.5,
                    //       indent: 60,
                    //       endIndent: 5,
                    //     )),
                    //     Text('Hoặc', style: TextStyle(color: Colors.black)),
                    //     Flexible(
                    //         child: Divider(
                    //       color: Colors.black,
                    //       thickness: 0.5,
                    //       indent: 5,
                    //       endIndent: 60,
                    //     )),
                    //   ],
                    // ),
                    // const SizedBox(height: 5),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.transparent,
                    //     borderRadius: BorderRadius.circular(50),
                    //   ),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: const Image(
                    //       image: AssetImage('assets/images/google.png'),
                    //       height: 30,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

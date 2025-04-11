import 'package:do_an_ck/controller/user/user_controller.dart';
import 'package:do_an_ck/services/user_service.dart';
import 'package:get/get.dart';

class Userbinding extends Bindings {
  @override
  void dependencies() {
    Get.put<UserService>(UserService());
    Get.put<UserController>(UserController(userService: Get.find<UserService>()));
  }
}
import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:get/get.dart';

class Authbinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
import 'package:do_an_ck/controller/cart/cart_controller.dart';
import 'package:get/get.dart';

class Cartbinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CartController());
  }
}
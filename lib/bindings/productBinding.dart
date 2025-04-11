import 'package:do_an_ck/controller/product/product_controller.dart';
import 'package:get/get.dart';

class Productbinding extends Bindings{
  @override
  void dependencies() {
    Get.put(ProductController());
  }
}
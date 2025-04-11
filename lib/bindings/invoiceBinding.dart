import 'package:do_an_ck/controller/invoice/invoice_controller.dart';
import 'package:get/get.dart';

class Invoicebinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InvoiceController());
  }
}
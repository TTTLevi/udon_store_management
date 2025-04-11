import 'package:do_an_ck/controller/invoice/invoice_list_controller.dart';
import 'package:get/get.dart';

class OrderListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InvoiceListController());
  }
}
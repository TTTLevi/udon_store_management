import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/controller/cart/cart_controller.dart';
import 'package:do_an_ck/models/invoice.dart';
import 'package:do_an_ck/pages/staffs/widgets/bot_navbar_staff.dart';
import 'package:do_an_ck/services/invoice_service.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.find<AuthController>();
  final InvoiceService invoiceService = InvoiceService();

  final isLoading = false.obs;

  String generateVietQRUrl(
      double amount, String accountNumber, String accountName, String addInfo) {
    const bankCode = 'vietcombank';
    final encodedAccountName = Uri.encodeComponent(accountName);
    final encodedAddInfo = Uri.encodeComponent(addInfo);
    final amountInt = amount.toInt();

    return 'https://img.vietqr.io/image/$bankCode-$accountNumber-qr_only.png'
        '?amount=$amountInt'
        '&addInfo=$encodedAddInfo'
        '&accountName=$encodedAccountName';
  }

  Future<void> checkout(String paymentMethod) async {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar('Lỗi', 'Giỏ hàng trống');
      return;
    }

    if (authController.userName.value.isEmpty) {
      Get.snackbar('Lỗi', 'Không lấy được tên nhân viên');
      return;
    }

    isLoading.value = true;
    try {
      final invoice = Invoice(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          staffId: authController.authService.auth.currentUser!.uid,
          staffName: authController.userName.value,
          items: cartController.cartItems.toList(),
          totalAmount: cartController.totalPrice,
          timeStamp: DateTime.now(),
          paymentMethod: paymentMethod);

      if (paymentMethod == 'cash') {
        // Lưu hóa đơn và tạo PDF khi thanh toán bằng tiền mặt
        await invoiceService.saveInvoice(invoice);
        final pdfFile = await invoiceService.generateInvoicePDF(invoice);

        Get.back(); // Đóng dialog chọn phương thức thanh toán
        cartController.clearCart(); // Xóa giỏ hàng khi thanh toán thành công
        Get.snackbar('Thành công', 'Đã thanh toán thành công');

        // Điều hướng về Homepage và mở PDF sau khi build phase hoàn tất
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final navController = Get.find<NavigationController>(tag: 'staff-nav');
          navController.changeIndex(0); // Chuyển về Homepage
          invoiceService.openPDF(pdfFile); // Mở PDF
        });
      } else if (paymentMethod == 'credit') {
        Get.back(); // Đóng dialog chọn phương thức thanh toán
        String qrUrl = generateVietQRUrl(
            cartController.totalPrice,
            '1033034597',
            'Tong Thien Thanh',
            'Thanh toán đơn hàng ${invoice.id}');
        Get.dialog(
          AlertDialog(
            title: const Text('Thanh toán bằng QR'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Quét QR để thanh toán ${currencyFormat(cartController.totalPrice)}'),
                const SizedBox(height: 20),
                Container(
                    width: 200,
                    height: 200,
                    child: Image.network(
                      qrUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('Lỗi tải QR'));
                      },
                    )),
                const SizedBox(height: 20),
                const Text('Quét mã này để thanh toán đơn hàng'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Đóng dialog QR
                  Get.back(); // Đóng dialog chọn phương thức thanh toán
                  Get.snackbar(
                    'Thông báo',
                    'Đã hủy thanh toán bằng QR',
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                  );
                },
                child: const Text('Hủy', style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () async {
                  // Lưu hóa đơn và tạo PDF khi người dùng xác nhận đã thanh toán
                  await invoiceService.saveInvoice(invoice);
                  final pdfFile = await invoiceService.generateInvoicePDF(invoice);

                  Get.back(); // Đóng dialog QR
                  cartController.clearCart(); // Xóa giỏ hàng khi thanh toán thành công
                  Get.snackbar('Thành công', 'Đã thanh toán thành công');

                  // Điều hướng về Homepage và mở PDF sau khi build phase hoàn tất
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final navController = Get.find<NavigationController>(tag: 'staff-nav');
                    navController.changeIndex(0); // Chuyển về Homepage
                    invoiceService.openPDF(pdfFile); // Mở PDF
                  });
                },
                child: const Text('Đã thanh toán'),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    } catch (e) {
      _handleError(e); // Xử lý lỗi chi tiết
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic error) {
    String errorMessage;
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          errorMessage = 'Bạn không có quyền thực hiện thao tác này.';
          break;
        case 'unavailable':
          errorMessage = 'Dịch vụ hiện không khả dụng. Vui lòng thử lại sau.';
          break;
        default:
          errorMessage = 'Có lỗi xảy ra: ${error.message}';
      }
    } else {
      errorMessage = 'Có lỗi xảy ra: $error';
    }
    Get.snackbar('Lỗi', errorMessage, snackPosition: SnackPosition.BOTTOM);
    print('Checkout error: $error');
  }
}
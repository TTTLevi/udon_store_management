import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/controller/cart/cart_controller.dart';
import 'package:do_an_ck/controller/invoice/invoice_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final InvoiceController invoiceController = Get.put(InvoiceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách món',
            style: TextStyle(color: AppColors.secondary)),
        backgroundColor: AppColors.light,
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return const Center(
              child: Text('Không có món ăn',
                  style: TextStyle(fontSize: 20, color: Colors.grey)),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return ListTile(
                      leading: Image.network(
                        item.product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.product.name),
                      subtitle: Text(
                          'Đơn giá: ${currencyFormat(item.product.price)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              cartController.updateQuantity(
                                  item.product.id, item.quantity - 1);
                            },
                          ),
                          Text('${item.quantity}',
                              style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cartController.updateQuantity(
                                  item.product.id, item.quantity + 1);
                            },
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cartController.removeFromCart(item.product.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng tiền:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          currencyFormat(cartController.totalPrice),
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton(
                        onPressed: invoiceController.isLoading.value
                            ? null
                            : () {
                                Get.dialog(
                                  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Text(
                                        'Chọn phương thức thanh toán',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.money,
                                              color: Colors.green),
                                          title: const Text('Tiền mặt'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onTap: () => invoiceController
                                              .checkout('cash'),
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.qr_code,
                                              color: Colors.blue),
                                          title: const Text('Thẻ tín dụng'),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onTap: () => invoiceController
                                              .checkout('credit'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Hủy',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.light,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: invoiceController.isLoading.value
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.secondary),
                              )
                            : const Text(
                                'Thanh toán',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondary),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:do_an_ck/controller/cart/cart_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffProductDetail extends StatelessWidget {
  const StaffProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments;
    final cartController = Get.put(CartController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 41,
                left: 10,
                child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back, color: AppColors.secondary),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              if (product.tag != null && product.tag.isNotEmpty)
                Positioned(
                  right: 10,
                  top: 41,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      product.tag,
                      style: const TextStyle(
                          fontSize: 16, color: AppColors.secondary),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.bgAppbar,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    const SizedBox(height: 15),
                    const Text('Mô tả:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 21),
                    Text(
                      product.description,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 15),
                    Divider(
                      color: Colors.grey.shade300,
                      thickness: 1,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Giá:', style: TextStyle(fontSize: 20)),
                            Text(
                              currencyFormat(product.price),
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.third),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cartController.addToCart(product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.third,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: const Text(
                            'Chọn món',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

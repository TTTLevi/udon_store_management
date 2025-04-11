import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/controller/product/product_controller.dart';
import 'package:do_an_ck/pages/common/widgets/category_chip.dart';
import 'package:do_an_ck/pages/staffs/widgets/product_card.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatelessWidget {
  final nameController = TextEditingController();
  final productController = Get.find<ProductController>();

  Homepage({super.key}) {
    nameController.addListener(
      () {
        productController.updateSearchQuery(nameController.text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(() => Text('Xin chào, ${extractLastName(controller.userName.value)}',
            style: const TextStyle(color: AppColors.secondary, fontSize: 21))),
        actions: [
          IconButton(
            onPressed: () {
              controller.signOut();
            },
            icon: const Icon(Icons.logout, color: AppColors.secondary),
          ),
        ],
        backgroundColor: AppColors.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                  ),
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.light,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    right: 20,
                    child: Container(
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập tên sản phẩm',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 75,
                    right: 20,
                    left: 20,
                    child: Wrap(
                      // Loại bỏ Obx ở đây
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      children: [
                        CategoryChip(label: 'All', category: 'all'),
                        CategoryChip(label: 'Udon', category: 'udon'),
                        CategoryChip(label: 'Toppings', category: 'toppings'),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Danh sách sản phẩm',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.62,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 21,
                              mainAxisSpacing: 21,
                            ),
                            itemCount:
                                productController.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product =
                                  productController.filteredProducts[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed('/staff-product-detail',
                                      arguments: product);
                                },
                                child: HomeProductCard(
                                  product: product,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

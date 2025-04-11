import 'package:do_an_ck/controller/product/product_controller.dart';
import 'package:do_an_ck/pages/admin/widgets/product_card.dart';
import 'package:do_an_ck/pages/common/widgets/category_chip.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Product extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final nameController = TextEditingController();

  Product({super.key}) {
    nameController.addListener(
      () {
        productController.updateSearchQuery(nameController.text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text('Sản phẩm',
            style: TextStyle(color: AppColors.secondary, fontSize: 23)),
        backgroundColor: AppColors.light,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/add-product');
            },
            icon: const Icon(Icons.add, color: AppColors.secondary, size: 27),
          ),
        ],
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: productController.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product =
                                productController.filteredProducts[index];
                            return ProductCard(
                              name: product.name,
                              imageUrl: product.imageUrl,
                              price: product.price,
                              onDelete: () {
                                Get.defaultDialog(
                                  title: 'Xóa sản phẩm',
                                  middleText:
                                      'Bạn có chắc chắn muốn xóa sản phẩm này?',
                                  textConfirm: 'Xóa',
                                  textCancel: 'Hủy',
                                  confirmTextColor: Colors.white,
                                  cancelTextColor: AppColors.error,
                                  onConfirm: () {
                                    productController.deleteProduct(product.id);
                                    Get.back();
                                  },
                                  onCancel: () {
                                    Get.back();
                                  },
                                );
                              },
                              onEdit: () {
                                Get.toNamed('/add-product', arguments: product);
                              },
                              onTap: () {
                                Get.toNamed('/product-detail',
                                    arguments: product);
                              },
                            );
                          },
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

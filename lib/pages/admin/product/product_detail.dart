import 'package:do_an_ck/controller/product/product_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final product = Get.arguments; 
    final isDeleting = false.obs; 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(color: AppColors.secondary, fontSize: 27),
        ),
        centerTitle: true,
        backgroundColor: AppColors.light,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh sản phẩm
                Stack(
                  children: [
                    Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(product.imageUrl),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) => const Icon(
                            Icons.error,
                            size: 100,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    if (product.tag != null && product.tag.isNotEmpty)
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.tag,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 76, 75, 75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                // Thông tin sản phẩm
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Giá: ${currencyFormat(product.price)}',
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Danh mục: ${product.category}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Mô tả:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Nút Sửa và Xóa
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.info,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            Get.toNamed('/add-product', arguments: product);
                          },
                          child: const Text(
                            'Sửa',
                            style: TextStyle(
                              color: AppColors.third,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Xác nhận xóa',
                              middleText:
                                  'Bạn có chắc chắn muốn xóa sản phẩm này?',
                              textConfirm: 'Xóa',
                              textCancel: 'Hủy',
                              confirmTextColor: Colors.white,
                              cancelTextColor: AppColors.error,
                              onConfirm: () async {
                                try {
                                  isDeleting.value = true;
                                  await productController
                                      .deleteProduct(product.id);
                                  Get.back();
                                  Get.offNamedUntil(
                                    '/admin',
                                    (route) => false,
                                    arguments: 1,
                                  );
                                  Get.snackbar(
                                      'Thành công', 'Xóa sản phẩm thành công');
                                } catch (e) {
                                  Get.snackbar(
                                      'Lỗi', 'Có lỗi xảy ra khi xóa sản phẩm');
                                } finally {
                                  isDeleting.value = false;
                                }
                              },
                            );
                          },
                          child: const Text(
                            'Xóa',
                            style: TextStyle(
                              color: AppColors.third,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Hiển thị loading khi xóa
          Obx(() {
            return isDeleting.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.secondary),
                      ),
                    ),
                  )
                : const SizedBox();
          }),
        ],
      ),
    );
  }
}

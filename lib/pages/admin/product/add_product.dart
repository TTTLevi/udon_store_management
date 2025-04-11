import 'package:do_an_ck/controller/product/add_product_controller.dart';
import 'package:do_an_ck/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:do_an_ck/utils/colors.dart';

class AddProductScreen extends StatelessWidget {
  

  AddProductScreen({super.key});

  final AddProductController controller = Get.put(AddProductController());
  final Product? product = Get.arguments;
  
  @override
  Widget build(BuildContext context) {
    if (product != null) {
      controller.loadProductData(product!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product == null ? 'Thêm sản phẩm' : 'Sửa sản phẩm',
          style: const TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: AppColors.light,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Obx(() {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.third),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.imageFile.value == null
                          ? (product != null &&
                                  controller.imageUrl.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    controller.imageUrl.value,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                  ),
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          size: 40, color: AppColors.third),
                                      SizedBox(height: 10),
                                      Text('Chọn hình ảnh',
                                          style: TextStyle(
                                              color: AppColors.third)),
                                    ],
                                  ),
                                ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                controller.imageFile.value!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.name,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.price,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Giá (VNĐ)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.tag,
                  decoration: const InputDecoration(
                    labelText: 'Tag (ví dụ: Must try, New product)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value.isEmpty
                        ? null
                        : controller.selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Danh mục',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'udon', child: Text('Udon')),
                      DropdownMenuItem(
                          value: 'toppings', child: Text('Toppings')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedCategory.value = value;
                      }
                    },
                  );
                }),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      product == null
                          ? controller.addProduct()
                          : controller.updateProduct(product!.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      product == null ? 'Thêm sản phẩm' : 'Cập nhật sản phẩm',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return controller.isLoading.value
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

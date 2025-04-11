import 'package:do_an_ck/controller/product/product_controller.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.label, required this.category});
  final String label;
  final String category;

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return GestureDetector(
      onTap: () {
        // Khi nhấn vào chip, cập nhật selectedCategory và lọc sản phẩm theo category
        productController.selectedCategory.value = category;
        productController.filterProductByCategory(category);
      },
      child: Obx(() { // Chỉ bọc widget cần cập nhật trạng thái bên trong Obx
        bool isSelected = productController.selectedCategory.value == category;
        return Chip(
          label: Text(label),
          backgroundColor: isSelected ? Colors.blue : AppColors.light,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.third,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? Colors.blue : AppColors.third,
            ),
          ),
        );
      }),
    );
  }
}

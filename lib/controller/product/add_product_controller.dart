import 'dart:io';

import 'package:do_an_ck/models/product.dart';
import 'package:do_an_ck/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  final Rx<File?> imageFile = Rx<File?>(null);
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final tag = TextEditingController();
  final selectedCategory = ''.obs;
  final imageUrl = ''.obs;
  final isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  final ProductService _productService = ProductService();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }


  Future<void> addProduct() async {
    if (imageFile.value == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn ảnh sản phẩm');
      return;
    }
    if (name.text.isEmpty ||
        description.text.isEmpty ||
        price.text.isEmpty ||
        selectedCategory.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    double? parsedPrice;
    try {
      parsedPrice = double.parse(price.text.trim());
      if (parsedPrice < 0) {
        Get.snackbar('Lỗi', 'Giá sản phẩm không thể là số âm');
        return;
      }
    } on FormatException {
      Get.snackbar('Lỗi', 'Giá sản phẩm phải là một số hợp lệ (ví dụ: 100000)');
      return;
    }

    try {
      isLoading.value = true;

      final productExists = await _productService.checkProductExistsByName(name.text.trim());
      if (productExists) {
        Get.snackbar('Lỗi', 'Sản phẩm "${name.text.trim()}" đã tồn tại');
        isLoading.value = false;
        return;
      }

      final imageUrl = await _productService.uploadImage(imageFile.value!);

      final newProduct = Product(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name.text.trim(),
          description: description.text.trim(),
          price: parsedPrice,
          imageUrl: imageUrl,
          category: selectedCategory.value,
          tag: tag.text.trim());
      await _productService.addProduct(newProduct);
      resetForm();
      Get.offNamedUntil(
        '/admin',
        (route) => false,
        arguments: 1,
      );
      Get.snackbar('Thành công', 'Thêm sản phẩm thành công');
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi thêm sản phẩm');
      print('Add product error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(String productId) async {
    if (name.text.isEmpty ||
        description.text.isEmpty ||
        price.text.isEmpty ||
        selectedCategory.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    double? parsedPrice;
    try {
      parsedPrice = double.parse(price.text.trim());
      if (parsedPrice < 0) {
        Get.snackbar('Lỗi', 'Giá sản phẩm không thể là số âm');
        return;
      }
    } on FormatException {
      Get.snackbar('Lỗi', 'Giá sản phẩm phải là một số hợp lệ (ví dụ: 100000)');
      return;
    }

    try {
      isLoading.value = true;
      String updatedImageUrl = imageUrl.value;
      if (imageFile.value != null) {
        updatedImageUrl = await _productService.uploadImage(imageFile.value!);
      }

      final updatedProduct = Product(
          id: productId,
          name: name.text.trim(),
          description: description.text.trim(),
          price: parsedPrice,
          imageUrl: updatedImageUrl,
          category: selectedCategory.value,
          tag: tag.text.trim());
      await _productService.updateProduct(updatedProduct);
      resetForm();
      Get.offNamedUntil(
        '/admin',
        (route) => false,
        arguments: 1,
      );
      Get.snackbar('Thành công', 'Cập nhật sản phẩm thành công');
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi cập nhật sản phẩm');
      print('Update product error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadProductData(Product product) {
    name.text = product.name;
    price.text = product.price.toString();
    description.text = product.description;
    tag.text = product.tag;
    selectedCategory.value = product.category;
    imageUrl.value = product.imageUrl;
    imageFile.value = null;
  }

  void resetForm() {
    name.clear();
    price.clear();
    description.clear();
    tag.clear();
    selectedCategory.value = '';
    imageFile.value = null;
    imageUrl.value = '';
  }
}

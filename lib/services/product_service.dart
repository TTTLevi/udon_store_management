import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:do_an_ck/models/product.dart';
import 'package:get/get.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final cloudinary =
      CloudinaryPublic('ddoilk2yn', 'flutter_udon_upload', cache: false);

  Stream<List<QueryDocumentSnapshot>> getAllProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').doc(product.id).set({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'category': product.category,
        'tag': product.tag,
      });
      Get.snackbar('Thành công', 'Sản phẩm đã được thêm');
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi thêm sản phẩm');
      print('Add product error: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore.collection('products').doc(product.id).update({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'category': product.category,
        'tag': product.tag,
      });
      Get.snackbar('Thành công', 'Sản phẩm đã được cập nhật');
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi cập nhật sản phẩm');
      print('Update product error: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      Get.snackbar('Thành công', 'Sản phẩm đã được xóa');
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra khi xóa sản phẩm');
      print('Delete product error: $e');
    }
  }

  Future<String> uploadImage(File image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image.path,
            resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể upload hình ảnh: $e');
      rethrow;
    }
  }

  Future<bool> checkProductExistsByName(String name) async {
    final querySnapshot = await _firestore
        .collection('products')
        .where('name', isEqualTo: name.trim())
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<Product> fetchProductById(String productId) async {
    final doc = await _firestore.collection('products').doc(productId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return Product(
        id: doc.id,
        name: data['name'],
        description: data['description'],
        price: data['price'],
        imageUrl: data['imageUrl'],
        category: data['category'],
        tag: data['tag'],
      );
    } else {
      throw Exception('Product not found');
    }
  }

}

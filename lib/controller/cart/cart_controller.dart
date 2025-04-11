import 'package:do_an_ck/models/cart_item.dart';
import 'package:do_an_ck/models/product.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  void addToCart(Product product) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity++;
    } else {
      cartItems.add(CartItem(product: product));
    }
    cartItems.refresh();
    Get.snackbar('Thành công', 'Đã thêm "${product.name}"');
  }

  void updateQuantity(String productId, int newQuantity){
    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == productId);
    if (existingItemIndex != -1) {
      if (newQuantity <= 0) {
        cartItems.removeAt(existingItemIndex);
      } else {
        cartItems[existingItemIndex].quantity = newQuantity;
      }
    }
    cartItems.refresh();
  }

  void removeFromCart(String productId) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.product.id == productId);
    if (existingItemIndex != -1) {
      cartItems.removeAt(existingItemIndex);
      Get.snackbar('Thành công', 'Đã xóa sản phẩm khỏi giỏ hàng');
    }
  }

  double get totalPrice {
    return cartItems.fold(0, (total, item) => total + item.totalPrice);
  }

  void clearCart() {
    cartItems.clear();
    Get.snackbar('Thành công', 'Giỏ hàng đã được làm sạch');
  }
}

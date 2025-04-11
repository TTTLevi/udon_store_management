import 'package:do_an_ck/models/product.dart';
import 'package:do_an_ck/services/product_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final products = <Product>[].obs;
  // final isLoading = false.obs;
  final filteredProducts = <Product>[].obs;
  final selectedCategory = 'all'.obs;
  final searchQuery = ''.obs;

  final ProductService _productService = ProductService();

  @override
  void onInit() {
    super.onInit();

    fetchAllProducts();
  }

  void fetchAllProducts(){
    _productService.getAllProducts().listen((snapshot){
      products.assignAll(snapshot.map((doc) {
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
      }).toList());
      filterProducts();
    });
  }

  Future<void> addProduct(Product product) async {
    await _productService.addProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _productService.deleteProduct(productId);
  }

  void filterProducts() {
    List<Product> tempProducts = products;

    // Lọc theo category
    if (selectedCategory.value != 'all') {
      tempProducts = tempProducts
          .where((product) => product.category == selectedCategory.value)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => product.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredProducts.assignAll(tempProducts);
  }

  void filterProductByCategory(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterProducts();
  }

}

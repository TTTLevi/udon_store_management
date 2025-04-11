import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck/models/cart_item.dart';
import 'package:do_an_ck/models/invoice.dart';
import 'package:do_an_ck/models/product.dart';
import 'package:get/get.dart';

class InvoiceListController extends GetxController {
  RxList<Invoice> invoices = <Invoice>[].obs;
  RxList<Invoice> filteredInvoices = <Invoice>[].obs;
  var isLoading = false.obs;
  var filterMode = 'newest'.obs;
  RxMap<String, Product> productCache = <String, Product>{}.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchInvoicesRealtime();
  }

  Future<void> preloadProducts() async {
    try {
      final products = await _firestore.collection('products').get();
      productCache.value = {
        for (var doc in products.docs)
          doc.id: Product(
            id: doc.id,
            name: doc['name'],
            description: doc['description'],
            price: doc['price'].toDouble(),
            imageUrl: doc['imageUrl'],
            category: doc['category'],
            tag: doc['tag'],
          )
      };
      print('Preloaded ${productCache.length} products into cache');
    } catch (e) {
      print('Error preloading products: $e');
    }
  }

  void fetchInvoicesRealtime() {
    isLoading.value = true;
    print('Starting to fetch invoices...');

    preloadProducts().then((_) {
      _firestore.collection('bills').snapshots().listen((snapshot) {
        if (snapshot.docs.isEmpty) {
          print('No bills found in Firestore');
          invoices.value = [];
          filteredInvoices.value = [];
          isLoading.value = false;
          return;
        }

        print('Found ${snapshot.docs.length} bills');
        invoices.value = snapshot.docs.map((doc) {
          final data = doc.data();
          print('Processing bill: ${data['id']}');

          final items = (data['items'] as List).map((item) {
            final productId = item['productId'];
            final product = productCache[productId] ??
                Product(
                  id: productId,
                  name: item['name'] ?? 'Unknown Product',
                  description: '',
                  price: item['price']?.toDouble() ?? 0.0,
                  imageUrl: '',
                  category: '',
                  tag: '',
                );
            return CartItem(
              product: product,
              quantity: item['quantity'] ?? 0,
            );
          }).toList();

          return Invoice(
            id: data['id'],
            staffId: data['staffId'],
            staffName: data['staffName'],
            items: items,
            totalAmount: data['totalAmount']?.toDouble() ?? 0.0,
            timeStamp: DateTime.parse(data['timeStamp']),
            paymentMethod: data['paymentMethod'],
          );
        }).toList();

        applyFilter();
        isLoading.value = false;
      }, onError: (e) {
        Get.snackbar('Lỗi', 'Không thể lắng nghe dữ liệu hóa đơn: $e');
        print('Stream error: $e');
        isLoading.value = false;
      });
    }).catchError((e) {
      Get.snackbar('Lỗi', 'Không thể tải danh sách sản phẩm: $e');
      print('Error preloading products: $e');
      isLoading.value = false;
    });
  }

  void applyFilter() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    switch (filterMode.value) {
      case 'newest':
        filteredInvoices.value = List.from(invoices)
          ..sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
        break;
      case 'oldest':
        filteredInvoices.value = List.from(invoices)
          ..sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
        break;
      case 'today':
        filteredInvoices.value = invoices.where((invoice) {
          return invoice.timeStamp.isAfter(startOfDay) &&
              invoice.timeStamp.isBefore(endOfDay);
        }).toList()
          ..sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
        break;
      default:
        filteredInvoices.value = List.from(invoices);
    }
    print('Filtered invoices: ${filteredInvoices.length}');
  }

  void setFilter(String mode) {
    filterMode.value = mode;
    applyFilter();
  }
}
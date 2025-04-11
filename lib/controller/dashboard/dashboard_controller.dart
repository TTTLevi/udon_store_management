import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_ck/models/invoice.dart';
import 'package:do_an_ck/services/authentication/authservice.dart';
import 'package:do_an_ck/services/invoice_service.dart';
import 'package:do_an_ck/services/product_service.dart';
import 'package:do_an_ck/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController{
  final InvoiceService invoiceService = InvoiceService();
  final ProductService productService = ProductService();
  final UserService userService = UserService();
  final Authservice authservice = Authservice();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var revenue = 0.0.obs;
  var orderCount = 0.obs;
  var userCount = 0.obs;
  var productCount = 0.obs;

  var recentInvoices = <Invoice>[].obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    fetchRecentInvoices();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      final invoiceSnapshot = await _firestore.collection('bills').get();
      double totalRevenue = 0.0;
      for (var doc in invoiceSnapshot.docs) {
        try {
          final invoice = Invoice.fromJson(doc.data()..['id'] = doc.id);
          totalRevenue += invoice.totalAmount;
        } catch (e) {
          print('Error parsing invoice ${doc.id}: $e');
          continue; 
        }
      }
      revenue.value = totalRevenue;
      orderCount.value = invoiceSnapshot.docs.length;

      final productSnapshot = await _firestore.collection('products').get();
      productCount.value = productSnapshot.docs.length;

      final users = await userService.getAllUsers();
      userCount.value = users.length;
    } catch (e) {
      print('Error fetching dashboard data: $e');
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      
      revenue.value = 0.0;
      orderCount.value = 0;
      productCount.value = 0;
      userCount.value = 0;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecentInvoices() async {
    try {
      isLoading.value = true;
      final invoiceSnapshot = await _firestore
          .collection('bills')
          .orderBy('timeStamp', descending: true)
          .limit(5)
          .get();

      final invoices = <Invoice>[];
      for (var doc in invoiceSnapshot.docs) {
        try {
          final invoice = Invoice.fromJson(doc.data()..['id'] = doc.id);
          invoices.add(invoice);
        } catch (e) {
          print('Error parsing invoice ${doc.id}: $e');
          continue; 
        }
      }
      recentInvoices.assignAll(invoices);
    } catch (e) {
      print('Error fetching recent invoices: $e');
      Get.snackbar('Lỗi', 'Không thể tải hóa đơn: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

}
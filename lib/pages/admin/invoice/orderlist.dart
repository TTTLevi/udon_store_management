import 'package:do_an_ck/controller/invoice/invoice_list_controller.dart';
import 'package:do_an_ck/pages/admin/invoice/order_detail.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Orderlist extends StatelessWidget {
  final InvoiceListController invoiceController =
      Get.find<InvoiceListController>();

  Orderlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        title: const Text(
          'Hóa đơn',
          style: TextStyle(
            fontSize: 27,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.light,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: AppColors.secondary),
            onSelected: (value) {
              invoiceController.setFilter(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'newest',
                child: Text('Mới nhất'),
              ),
              const PopupMenuItem(
                value: 'oldest',
                child: Text('Cũ nhất'),
              ),
              const PopupMenuItem(
                value: 'today',
                child: Text('Hôm nay'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (invoiceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (invoiceController.filteredInvoices.isEmpty) {
          return const Center(child: Text('Chưa có hóa đơn nào'));
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              const ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mã hóa đơn',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text('Tổng tiền',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue)),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: invoiceController.filteredInvoices.length,
                itemBuilder: (context, index) {
                  final invoice = invoiceController.filteredInvoices[index];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('#${invoice.id}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(currencyFormat(invoice.totalAmount),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    subtitle:
                        Text(formatDateTime(invoice.timeStamp.toString())),
                    onTap: () {
                      Get.to(
                        () => OrderDetailPage(invoice: invoice),
                        transition: Transition.rightToLeft,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

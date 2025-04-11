import 'package:do_an_ck/controller/auth/auth_controller.dart';
import 'package:do_an_ck/controller/dashboard/dashboard_controller.dart';
import 'package:do_an_ck/pages/admin/widgets/statcard.dart';
import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());
    final controller = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tổng quan',
            style: TextStyle(fontSize: 25, color: AppColors.secondary)),
        backgroundColor: AppColors.light,
        actions: [
          IconButton(
            onPressed: () {
              dashboardController.fetchDashboardData();
              dashboardController.fetchRecentInvoices();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              controller.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(
        () {
          if (dashboardController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Statcard(
                        title: 'Doanh thu',
                        value: NumberFormat.currency(
                                locale: 'vi_VN', symbol: 'VND')
                            .format(dashboardController.revenue.value),
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Statcard(
                        title: 'Số lượng đơn',
                        value: dashboardController.orderCount.value.toString(),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Statcard(
                        title: 'Số lượng món',
                        value:
                            dashboardController.productCount.value.toString(),
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Statcard(
                        title: 'Số tài khoản',
                        value: dashboardController.userCount.value.toString(),
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hóa đơn gần đây',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: dashboardController.recentInvoices.isEmpty
                      ? const Center(child: Text('Chưa có đơn nào'))
                      : ListView.builder(
                          itemCount: dashboardController.recentInvoices.length,
                          itemBuilder: (context, index) {
                            final invoice =
                                dashboardController.recentInvoices[index];
                            return ListTile(
                              leading:
                                  const Icon(Icons.receipt, color: Colors.blue),
                              title: Text('#${invoice.id}'),
                              subtitle: Text(
                                'Nhân viên: ${invoice.staffName}\n'
                                'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'VND').format(invoice.totalAmount)}',
                              ),
                              trailing: Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(invoice.timeStamp),
                                style: const TextStyle(fontSize: 12),
                              ),
                              onTap: () async {
                                final file = await dashboardController
                                    .invoiceService
                                    .generateInvoicePDF(invoice);
                                await dashboardController.invoiceService
                                    .openPDF(file);
                              },
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

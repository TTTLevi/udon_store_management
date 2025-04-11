import 'package:do_an_ck/utils/colors.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Thông báo',
          style: TextStyle(color: AppColors.secondary, fontSize: 27),
        ),
        backgroundColor: AppColors.light,
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Thông báo $index'),
            subtitle: Text('Nội dung thông báo $index'),
          );
        },
      ),
    );
  }
}

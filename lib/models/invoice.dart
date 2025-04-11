import 'package:do_an_ck/models/cart_item.dart';

class Invoice {
  final String id;
  final String staffId;
  final String staffName;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime timeStamp;
  final String paymentMethod;

  Invoice({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.items,
    required this.totalAmount,
    required this.timeStamp,
    required this.paymentMethod,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id']?.toString() ?? '',
      staffId: json['staffId']?.toString() ?? '',
      staffName: json['staffName']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      timeStamp: DateTime.tryParse(json['timeStamp']?.toString() ?? '') ??
          DateTime.now(),
      paymentMethod: json['paymentMethod']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'staffId': staffId,
        'staffName': staffName,
        'items': items.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'timeStamp': timeStamp.toIso8601String(),
        'paymentMethod': paymentMethod,
      };
}

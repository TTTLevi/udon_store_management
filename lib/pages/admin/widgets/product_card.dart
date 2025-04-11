import 'package:do_an_ck/utils/functions/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });
  final String name;
  final String imageUrl;
  final double price;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.4,
          children: [
            SlidableAction(
              onPressed: (context) => onEdit(),
              icon: Icons.edit,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: 'Sửa',
            ),
            SlidableAction(
              onPressed: (context) => onDelete(),
              icon: Icons.delete,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Xóa',
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 222, 190),
              border: Border.all(color: Colors.grey),
              // borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(imageUrl),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
              title: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17)),
              subtitle: Text(currencyFormat(price),
                  style: const TextStyle(fontSize: 15)),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

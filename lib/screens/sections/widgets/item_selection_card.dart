import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../models/cart_item_model.dart';
import '../../../providers/cart_provider.dart';

class ItemSelectionCard extends StatelessWidget {
  final String id, name, description, sectionId, sectionName, image;
  final double price;

  const ItemSelectionCard({
    required this.id, required this.name, required this.description,
    required this.sectionId, required this.sectionName, required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final isSelected = cart.isInCart(id);

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(description, style: TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2),
                SizedBox(height: 5),
                Text("₹${price.toStringAsFixed(0)}", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isSelected ? Icons.remove_circle : Icons.add_circle,
                color: isSelected ? Colors.red : AppColors.primary),
            onPressed: () {
              if (isSelected) cart.removeItem(id);
              else cart.addItem(CartItem(id: id, sectionId: sectionId, sectionName: sectionName, itemName: name, price: price, image: image));
            },
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../providers/cart_provider.dart';

class SectionTotalBar extends StatelessWidget {
  final String sectionId, sectionName;
  const SectionTotalBar({required this.sectionId, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double total = cart.getSectionTotal(sectionId);

    if (total == 0) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text("$sectionName Total", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text("₹${total.toStringAsFixed(0)}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ]),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Done"),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
          )
        ],
      ),
    );
  }
}
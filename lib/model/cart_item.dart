import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  late int quantity;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

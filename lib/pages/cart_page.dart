import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../model/cart_item.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Cart'),
          ),
          body: ctrl.cartItems.isEmpty
              ? Center(child: Text('No items in your cart'))
              : ListView.builder(
            itemCount: ctrl.cartItems.length,
            itemBuilder: (context, index) {
              var cartItem = ctrl.cartItems[index];
              return ListTile(
                leading: Image.network(cartItem.imageUrl, width: 10, height: 10),
                title: Text(cartItem.name),
                subtitle: Text('₹${cartItem.price} x ${cartItem.quantity}'),
                trailing: IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    ctrl.removeItemFromCart(cartItem); // Remove item from cart
                  },
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Checkout functionality
              },
              child: Text('Proceed to Checkout - ₹${ctrl.totalPrice}'),
            ),
          ),
        );
      },
    );
  }
}

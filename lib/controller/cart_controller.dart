import 'package:get/get.dart';
import 'package:footwear_client/model/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[];

  // Add item to the cart
  void addItemToCart(CartItem item) {
    var existingItem = cartItems.firstWhere(
            (cartItem) => cartItem.name == item.name,
        orElse: () => CartItem(name: '', imageUrl: '', price: 0)); // No matching item
    if (existingItem.name == '') {
      cartItems.add(item); // Add new item if not in the cart
    } else {
      existingItem.quantity += 1; // Increment quantity if item is already in cart
    }
    update(); // Update the UI
  }

  // Remove item from the cart
  void removeItemFromCart(CartItem item) {
    cartItems.remove(item);
    update(); // Update the UI
  }

  // Get total cart price
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }
}

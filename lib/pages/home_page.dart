import 'package:flutter/material.dart';
import 'package:footwear_client/controller/home_controller.dart';
import 'package:footwear_client/controller/cart_controller.dart';
import 'package:footwear_client/pages/cart_page.dart';
import 'package:footwear_client/pages/user_account_page.dart';
import 'package:footwear_client/widgets/drop_down_btn.dart';
import 'package:footwear_client/widgets/multi_select_drop_down.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../widgets/product_card.dart';
import '../model/cart_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Disable back button functionality
        return false;
      },
      child: GetBuilder<HomeController>(
        assignId: true,
        builder: (ctrl) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Text(
                'Footwear Store',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              backgroundColor: Colors.blueGrey,
            ),
            drawer: _buildNavigationDrawer(context),
            body: Column(
              children: [
                _buildCategoryChips(ctrl),
                _buildFilterOptions(ctrl),
                _buildProductGrid(ctrl),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build the navigation drawer for the menu bar
  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Get.to(() => CartPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Account'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Get.to(() => UserAccountPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              GetStorage().erase(); // Clear stored user data
              Get.offAllNamed('/login'); // Navigate to login page
            },
          ),
        ],
      ),
    );
  }

  /// Build the category chips for filtering products
  Widget _buildCategoryChips(HomeController ctrl) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey.shade200,
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ctrl.productCategories.length,
          itemBuilder: (context, index) {
            final categoryName =
                ctrl.productCategories[index].name ?? 'Unknown Category';
            return GestureDetector(
              onTap: () => ctrl.filterByCategory(categoryName),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Chip(
                  label: Text(
                    categoryName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.blue.shade100,
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build the filter and sort options
  Widget _buildFilterOptions(HomeController ctrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: DropDownBtn(
              items: ['Rp: Low to High', 'Rp: High to Low'],
              selectedItemText: 'Sort',
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              onSelected: (selected) {
                ctrl.sortByPrice(
                  ascending: selected == 'Rp: Low to High',
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: MultiSelectDropDown(
              items: ['Puma', 'New Balance', 'Adidas', 'Nike'],
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              onSelectionChanged: (selectedItems) {
                ctrl.filterByBrand(selectedItems);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build the product grid
  Widget _buildProductGrid(HomeController ctrl) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ctrl.productShowInUi.length,
        itemBuilder: (context, index) {
          final product = ctrl.productShowInUi[index];
          return ProductCard(
            name: product.name ?? 'No Name',
            imageUrl: product.image ?? 'url',
            price: product.price ?? 0,
            offerTag: '20% off',
            onTap: () {
              final cartCtrl = Get.find<CartController>();
              cartCtrl.addItemToCart(CartItem(
                name: product.name ?? 'No Name',
                imageUrl: product.image ?? 'url',
                price: product.price ?? 0,
              ));
              Get.to(() => CartPage());
            },
            onAddToCart: () {
              final cartCtrl = Get.find<CartController>();
              cartCtrl.addItemToCart(CartItem(
                name: product.name ?? 'No Name',
                imageUrl: product.image ?? 'url',
                price: product.price ?? 0,
              ));
            },
          );
        },
      ),
    );
  }
}

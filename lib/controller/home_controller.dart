import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/product/product.dart';
import '../model/product_category/product_category.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;

  // TextEditingControllers for AddProductPage
  final TextEditingController productNameCtrl = TextEditingController();
  final TextEditingController productCategoryCtrl = TextEditingController();
  final TextEditingController productBrandCtrl = TextEditingController();
  final TextEditingController productPriceCtrl = TextEditingController();
  final TextEditingController productDescriptionCtrl = TextEditingController();
  final TextEditingController productImgCtrl = TextEditingController();

  String category = '';
  String brand = '';
  bool offer = false;

  List<Product> products = [];
  List<Product> productShowInUi = [];
  List<ProductCategory> productCategories = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('category');
    try {
      await fetchCategory();
      await fetchProducts();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to initialize data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      products.assignAll(retrievedProducts);
      productShowInUi.assignAll(products);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch products: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      update();
    }
  }

  Future<void> fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs
          .map((doc) => ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      productCategories.assignAll(retrievedCategories);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch categories: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      update();
    }
  }

  void filterByCategory(String category) {
    if (category.isEmpty) {
      productShowInUi = products;
    } else {
      productShowInUi = products
          .where((product) => product.category?.toLowerCase() == category.toLowerCase())
          .toList();
    }
    update();
  }

  void filterByBrand(List<String> brands) {
    if (brands.isEmpty) {
      productShowInUi = products;
    } else {
      final lowerCaseBrands = brands.map((brand) => brand.toLowerCase()).toSet();
      productShowInUi = products.where((product) {
        return product.brand != null &&
            lowerCaseBrands.contains(product.brand!.toLowerCase());
      }).toList();
    }
    update();
  }

  void sortByPrice({required bool ascending}) {
    productShowInUi.sort((a, b) {
      if (a.price == null || b.price == null) return 0;
      return ascending ? a.price!.compareTo(b.price!) : b.price!.compareTo(a.price!);
    });
    update();
  }

  // Method to add a product
  Future<void> addProduct() async {
    final String name = productNameCtrl.text.trim();
    final String category = productCategoryCtrl.text.trim();
    final String brand = productBrandCtrl.text.trim();
    final String price = productPriceCtrl.text.trim();
    final String description = productDescriptionCtrl.text.trim();

    if (name.isEmpty || category.isEmpty || brand.isEmpty || price.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final double? priceValue = double.tryParse(price);
      if (priceValue == null) {
        Get.snackbar(
          'Error',
          'Invalid price value',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final product = Product(
        name: name,
        category: category,
        brand: brand,
        price: priceValue,
        description: description,
      );

      await productCollection.add(product.toJson());

      // Clear the text fields after adding
      clearTextFields();

      Get.snackbar(
        'Success',
        'Product added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Refresh product list
      await fetchProducts();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Clear all text fields
  void clearTextFields() {
    productNameCtrl.clear();
    productCategoryCtrl.clear();
    productBrandCtrl.clear();
    productPriceCtrl.clear();
    productDescriptionCtrl.clear();
  }

  @override
  void onClose() {
    // Dispose TextEditingControllers to avoid memory leaks
    productNameCtrl.dispose();
    productCategoryCtrl.dispose();
    productBrandCtrl.dispose();
    productPriceCtrl.dispose();
    productDescriptionCtrl.dispose();
    super.onClose();
  }
}

import 'package:flutter/material.dart';
import 'package:footwear_client/controller/home_controller.dart';
import 'package:footwear_client/widgets/drop_down_btn.dart';
import 'package:get/get.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
          backgroundColor: Colors.indigoAccent,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Add New Product',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: ctrl.productNameCtrl,
                  label: 'Product Name',
                  hintText: 'Enter Product Name',
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: ctrl.productDescriptionCtrl,
                  label: 'Product Description',
                  hintText: 'Enter Product Description',
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: ctrl.productImgCtrl,
                  label: 'Image URL',
                  hintText: 'Enter Image URL',
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: ctrl.productPriceCtrl,
                  label: 'Product Price',
                  hintText: 'Enter Product Price',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropDownBtn(
                        selectedItemText: ctrl.category,
                        onSelected: (selectedValue) {
                          ctrl.category = selectedValue ?? 'general';
                          ctrl.update();
                        },
                        textStyle: const TextStyle(color: Colors.black), items: [],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropDownBtn(
                        items: const ['Puma', 'Adidas', 'Docmarts', 'Sketchers'],
                        selectedItemText: ctrl.brand,
                        onSelected: (selectedValue) {
                          ctrl.brand = selectedValue ?? 'unbranded';
                          ctrl.update();
                        },
                        textStyle: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Offer Product?'),
                DropDownBtn(
                  items: const ['true', 'false'],
                  selectedItemText: ctrl.offer.toString(),
                  onSelected: (selectedValue) {
                    ctrl.offer = (selectedValue == 'true');
                    ctrl.update();
                  },
                  textStyle: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_validateInput(ctrl)) {
                        ctrl.addProduct();
                        Get.snackbar(
                          'Success',
                          'Product Added Successfully',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please fill all fields',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    child: const Text('Add Product'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelText: label,
        hintText: hintText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  bool _validateInput(HomeController ctrl) {
    return ctrl.productNameCtrl.text.isNotEmpty &&
        ctrl.productDescriptionCtrl.text.isNotEmpty &&
        ctrl.productImgCtrl.text.isNotEmpty &&
        ctrl.productPriceCtrl.text.isNotEmpty &&
        ctrl.category.isNotEmpty &&
        ctrl.brand.isNotEmpty;
  }
}

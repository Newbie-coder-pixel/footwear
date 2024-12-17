import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

String? selectedValue;

class DropDownBtn extends StatelessWidget {
  final List<String> items;
  final String selectedItemText;
  final Function(String?) onSelected;
  final TextStyle textStyle;

  const DropDownBtn({
    super.key,
    required this.items,
    required this.selectedItemText,
    required this.onSelected,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              selectedItemText,
              style: textStyle,
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: textStyle,
                ),
              );
            }).toList(),
            value: selectedValue,
            onChanged: (String? value) {
              onSelected(value);
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              width: 200,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}

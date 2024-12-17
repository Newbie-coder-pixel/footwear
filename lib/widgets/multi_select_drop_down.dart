import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MultiSelectDropDown extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;
  final TextStyle textStyle;

  const MultiSelectDropDown({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    required this.textStyle,
  });

  @override
  State<MultiSelectDropDown> createState() => _MultiSelectDropDownState();
}

class _MultiSelectDropDownState extends State<MultiSelectDropDown> {
  final List<String> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Items',
            style: widget.textStyle,
          ),
          items: widget.items.map((item) {
            return DropdownMenuItem(
              value: item,
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = _selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedItems.remove(item);
                        } else {
                          _selectedItems.add(item);
                        }
                        widget.onSelectionChanged(_selectedItems);
                      });
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank,
                            color: Colors.deepPurple,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item,
                              style: widget.textStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          value: _selectedItems.isEmpty ? null : _selectedItems.last,
          onChanged: (value) {},
          selectedItemBuilder: (context) {
            return widget.items.map((item) {
              return Container(
                alignment: AlignmentDirectional.center,
                child: Text(
                  _selectedItems.join(', '),
                  style: widget.textStyle.copyWith(overflow: TextOverflow.ellipsis),
                  maxLines: 1,
                ),
              );
            }).toList();
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 50,
            width: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 50,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

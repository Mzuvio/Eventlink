import 'package:flutter/material.dart';
import 'package:transitease_app/models/category.dart';
import 'package:transitease_app/utils/colors.dart';

class ToggleDropdown extends StatefulWidget {
  final String label;
  final List<Category> items;
  final Category? selectedItem;
  final Function(Category?) onChanged;

  const ToggleDropdown({
    super.key,
    required this.label,
    required this.items,
    this.selectedItem,
    required this.onChanged,
  });

  @override
  _ToggleDropdownState createState() => _ToggleDropdownState();
}

class _ToggleDropdownState extends State<ToggleDropdown> {
  bool _isEditing = false;
  Category? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing
        ? Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, -1),
                blurRadius: 20,
              ),
            ]),
            child: DropdownButtonFormField<Category>(
              dropdownColor: backgroundColor,
              value: _selectedItem,
              items: widget.items
                  .map(
                    (category) => DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.categoryName),
                    ),
                  )
                  .toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: widget.label,
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                  widget.onChanged(value);
                  _isEditing = false;
                });
              },
            ),
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: Row(
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xff28bca1).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    color: jetBlack,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _selectedItem?.categoryName ?? widget.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          );
  }
}

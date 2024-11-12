import 'package:flutter/material.dart';
import 'package:transitease_app/models/category.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [
    Category(
      categoryId: '1',
      categoryName: 'All',
    ),
    Category(
      categoryId: '2',
      categoryName: 'Sports',
    ),
    Category(
      categoryId: '3',
      categoryName: 'Culture',
    ),
    Category(
      categoryId: '4',
      categoryName: 'Meeting',
    ),
    Category(
      categoryId: '5',
      categoryName: 'Festival',
    ),
    Category(
      categoryId: '6',
      categoryName: 'Charity',
    ),
  ];

  List<Category> get categories => _categories;

  List<Map<String, dynamic>> toJson() {
    return _categories.map((category) => category.toMap()).toList();
  }
}

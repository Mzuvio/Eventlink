class Category {
  String categoryId;
  String categoryName;

  Category({
    required this.categoryId,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
    );
  }
}

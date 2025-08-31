class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    this.description = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      category: json['category'] ?? 'General',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'category': category,
      'description': description,
    };
  }
}

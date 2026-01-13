class Product {
  final String? id;
  final String title;
  final String description;
  final int price;
  final String section;
  final List<String> images;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.section,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      section: json['section'],
      images: List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "price": price,
      "section": section,
      "images": images,
    };
  }
}

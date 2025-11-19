import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<String> imageUrl;
  @HiveField(4)
  final double price;
  @HiveField(5)
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      imageUrl: (json['images'] as List<dynamic>?)
              ?.map((image) => image.toString())
              .toList() ??
          ['https://example.com/default-image.png'], // Default to a list
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Method to create a copy of the Product object
  Product copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? imageUrl,
    double? price,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
    );
  }
}

import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product {
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

  @HiveField(6)
  final String? thumbnail;

  @HiveField(7)
  final int quantity; // Add quantity field

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.rating,
    required this.thumbnail,
    this.quantity = 1, // Default quantity is 1
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description',
      imageUrl:
          (json['images'] as List<dynamic>?)
              ?.map((image) => image.toString())
              .toList() ??
          ['https://example.com/default-image.png'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail:
          json['thumbnail'] ??
          json['images']?[0] ??
          'https://example.com/default-thumbnail.png',
      quantity: json['quantity'] ?? 1,
    );
  }

  Product copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? imageUrl,
    double? price,
    double? rating,
    String? thumbnail,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      thumbnail: thumbnail ?? this.thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }
}

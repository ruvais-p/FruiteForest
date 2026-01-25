/// Store item model representing a purchasable item from Supabase store table
class StoreItem {
  final String id;
  final String name;
  final int points;
  final String? imageUrl;
  final String? description;
  final int? stock;

  StoreItem({
    required this.id,
    required this.name,
    required this.points,
    this.imageUrl,
    this.description,
    this.stock,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      name: json['store_element'],
      points: json['points'],
      imageUrl: json['image_url'],
      description: json['description'],
      stock: json['stock'],
    );
  }

  /// Check if item has an associated image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}

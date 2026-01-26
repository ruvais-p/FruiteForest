class StoreItem {
  final String id;
  final String name;
  final int points;
  final String? imageUrl;

  StoreItem({
    required this.id,
    required this.name,
    required this.points,
    this.imageUrl,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      name: json['store_element'],
      points: json['points'],
      imageUrl: json['image_url'],
    );
  }
}

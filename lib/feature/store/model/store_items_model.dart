class StoreItem {
  final String id;
  final String name;
  final int points;

  StoreItem({required this.id, required this.name, required this.points});

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      name: json['store_element'],
      points: json['points'],
    );
  }
}

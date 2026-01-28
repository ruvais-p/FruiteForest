class HistoryItem {
  final String id;
  final String itemName;
  final int quantity;
  final DateTime createdAt;
  final String status;
  final String? imageUrl;
  final int points;

  HistoryItem({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.createdAt,
    required this.status,
    this.imageUrl,
    required this.points,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      itemName: json['store']['store_element'] ?? 'Unknown Item',
      quantity: 1, // Default to 1 for now
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? 'pending',
      imageUrl: json['store']['image_url'],
      points: json['store']['points'] ?? 0,
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String item;
  final String? status;
  final DateTime? createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.item,
    this.status,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      item: json['item'],
      status: json['status'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'item': item,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

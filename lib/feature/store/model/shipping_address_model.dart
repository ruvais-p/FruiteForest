class ShippingAddress {
  final String uid;
  final String address;
  final String state;
  final String district;
  final String postOffice;
  final String postPin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ShippingAddress({
    required this.uid,
    required this.address,
    required this.state,
    required this.district,
    required this.postOffice,
    required this.postPin,
    this.createdAt,
    this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      uid: json['uid'],
      address: json['address'],
      state: json['state'],
      district: json['district'],
      postOffice: json['post_office'],
      postPin: json['post_pin'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'address': address,
      'state': state,
      'district': district,
      'post_office': postOffice,
      'post_pin': postPin,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class ActivityLog {
  final String id;
  final String uid;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String category;

  ActivityLog({
    required this.id,
    required this.uid,
    required this.startedAt,
    this.endedAt,
    required this.category,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'],
      uid: json['uid'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'category': category,
    };
  }
}

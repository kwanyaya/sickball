class SickLeaveModel {
  final String id;
  final String userId;
  final String reason;
  final DateTime date;
  final DateTime createdAt;

  SickLeaveModel({
    required this.id,
    required this.userId,
    required this.reason,
    required this.date,
    required this.createdAt,
  });

  factory SickLeaveModel.fromMap(Map<String, dynamic> map, String id) {
    return SickLeaveModel(
      id: id,
      userId: map['userId'] ?? '',
      reason: map['reason'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'reason': reason,
      'date': date.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  SickLeaveModel copyWith({
    String? id,
    String? userId,
    String? reason,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return SickLeaveModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reason: reason ?? this.reason,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

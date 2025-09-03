class ReasonModel {
  final String id;
  final String text;
  final String category;
  final String? lastUsedBy;
  final DateTime? lastUsedDate;

  ReasonModel({
    required this.id,
    required this.text,
    required this.category,
    this.lastUsedBy,
    this.lastUsedDate,
  });

  factory ReasonModel.fromMap(Map<String, dynamic> map, String id) {
    return ReasonModel(
      id: id,
      text: map['text'] ?? '',
      category: map['category'] ?? '',
      lastUsedBy: map['lastUsedBy'],
      lastUsedDate:
          map['lastUsedDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['lastUsedDate'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'category': category,
      'lastUsedBy': lastUsedBy,
      'lastUsedDate': lastUsedDate?.millisecondsSinceEpoch,
    };
  }

  ReasonModel copyWith({
    String? id,
    String? text,
    String? category,
    String? lastUsedBy,
    DateTime? lastUsedDate,
  }) {
    return ReasonModel(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      lastUsedBy: lastUsedBy ?? this.lastUsedBy,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
    );
  }
}

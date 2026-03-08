class RelapseLog {
  String? id;
  String todoId;
  DateTime relapsedAt;
  String? triggerNote;
  String? causeTag; // Plus: quick-tap cause chip (e.g. 'Stress', 'Boredom')

  RelapseLog({
    this.id,
    required this.todoId,
    DateTime? relapsedAt,
    this.triggerNote,
    this.causeTag,
  }) : relapsedAt = relapsedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoId': todoId,
      'relapsedAt': relapsedAt.toIso8601String(),
      'triggerNote': triggerNote,
      'causeTag': causeTag,
    };
  }

  static RelapseLog fromMap(Map<String, dynamic> map) {
    return RelapseLog(
      id: map['id'].toString(),
      todoId: map['todoId'].toString(),
      relapsedAt: DateTime.parse(map['relapsedAt']),
      triggerNote: map['triggerNote'],
      causeTag: map['causeTag'] as String?,
    );
  }
}

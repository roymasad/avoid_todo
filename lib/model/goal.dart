enum GoalType { streak, savingsMonth }

class Goal {
  final int? id;
  final GoalType type;

  /// For streak goals — the specific habit's id.
  final String? todoId;

  /// Denormalised display name for the habit (avoids a join on every render).
  final String? todoText;

  /// Target value: days for [GoalType.streak], dollars for [GoalType.savingsMonth].
  final double targetValue;

  final bool isActive;

  /// True = auto-generated for the free user (at most 1 at a time).
  final bool isPreset;

  final DateTime? completedAt;
  final DateTime createdAt;

  const Goal({
    this.id,
    required this.type,
    this.todoId,
    this.todoText,
    required this.targetValue,
    this.isActive = true,
    this.isPreset = false,
    this.completedAt,
    required this.createdAt,
  });

  Goal copyWith({
    int? id,
    bool? isActive,
    DateTime? completedAt,
  }) =>
      Goal(
        id: id ?? this.id,
        type: type,
        todoId: todoId,
        todoText: todoText,
        targetValue: targetValue,
        isActive: isActive ?? this.isActive,
        isPreset: isPreset,
        completedAt: completedAt ?? this.completedAt,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'type': type.name,
        'todoId': todoId,
        'todoText': todoText,
        'targetValue': targetValue,
        'isActive': isActive ? 1 : 0,
        'isPreset': isPreset ? 1 : 0,
        'completedAt': completedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  static Goal fromMap(Map<String, dynamic> map) => Goal(
        id: map['id'] as int?,
        type: GoalType.values.firstWhere(
          (t) => t.name == map['type'],
          orElse: () => GoalType.streak,
        ),
        todoId: map['todoId'] as String?,
        todoText: map['todoText'] as String?,
        targetValue: (map['targetValue'] as num).toDouble(),
        isActive: (map['isActive'] as int) == 1,
        isPreset: (map['isPreset'] as int) == 1,
        completedAt: map['completedAt'] != null
            ? DateTime.tryParse(map['completedAt'] as String)
            : null,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}

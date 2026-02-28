enum TodoPriority { high, medium, low }

class ToDo {
  String? id;
  String? todoText;
  List<String> tagIds; // replaces single category
  TodoPriority priority;
  int orderIndex;
  DateTime createdAt;
  DateTime updatedAt;
  bool isArchived;
  DateTime? archivedAt;

  // Phase 1 fields
  bool isRecurring;
  DateTime? eventDate;
  DateTime lastRelapsedAt;
  int relapseCount;
  double? estimatedCost; // Phase 3

  ToDo({
    this.id,
    required this.todoText,
    List<String>? tagIds,
    this.priority = TodoPriority.medium,
    this.orderIndex = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isArchived = false,
    this.archivedAt,
    this.isRecurring = true,
    this.eventDate,
    DateTime? lastRelapsedAt,
    this.relapseCount = 0,
    this.estimatedCost,
  })  : tagIds = tagIds ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        lastRelapsedAt = lastRelapsedAt ?? createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'priority': priority.index,
      'orderIndex': orderIndex,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isArchived': isArchived ? 1 : 0,
      'archivedAt': archivedAt?.toIso8601String(),
      'isRecurring': isRecurring ? 1 : 0,
      'eventDate': eventDate?.toIso8601String(),
      'lastRelapsedAt': lastRelapsedAt.toIso8601String(),
      'relapseCount': relapseCount,
      'estimatedCost': estimatedCost,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map, {List<String>? tagIds}) {
    return ToDo(
      id: map['id'].toString(),
      todoText: map['todoText'],
      tagIds: tagIds ?? [],
      priority: TodoPriority.values[map['priority'] ?? 1],
      orderIndex: map['orderIndex'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isArchived: map['isArchived'] == 1,
      archivedAt:
          map['archivedAt'] != null ? DateTime.parse(map['archivedAt']) : null,
      isRecurring: map['isRecurring'] == null ? true : map['isRecurring'] == 1,
      eventDate:
          map['eventDate'] != null ? DateTime.parse(map['eventDate']) : null,
      lastRelapsedAt: map['lastRelapsedAt'] != null
          ? DateTime.parse(map['lastRelapsedAt'])
          : null,
      relapseCount: map['relapseCount'] ?? 0,
      estimatedCost: map['estimatedCost'] != null
          ? (map['estimatedCost'] as num).toDouble()
          : null,
    );
  }

  ToDo copyWith({
    String? id,
    String? todoText,
    List<String>? tagIds,
    TodoPriority? priority,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    DateTime? archivedAt,
    bool? isRecurring,
    DateTime? eventDate,
    DateTime? lastRelapsedAt,
    int? relapseCount,
    double? estimatedCost,
  }) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      tagIds: tagIds ?? List.from(this.tagIds),
      priority: priority ?? this.priority,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
      isRecurring: isRecurring ?? this.isRecurring,
      eventDate: eventDate ?? this.eventDate,
      lastRelapsedAt: lastRelapsedAt ?? this.lastRelapsedAt,
      relapseCount: relapseCount ?? this.relapseCount,
      estimatedCost: estimatedCost ?? this.estimatedCost,
    );
  }
}

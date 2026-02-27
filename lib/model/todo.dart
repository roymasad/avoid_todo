enum TodoCategory { health, productivity, social, other }

enum TodoPriority { high, medium, low }

class ToDo {
  String? id;
  String? todoText;
  TodoCategory category;
  TodoPriority priority;
  int orderIndex;
  DateTime createdAt;
  DateTime updatedAt;
  bool isArchived;
  DateTime? archivedAt;

  ToDo({
    this.id,
    required this.todoText,
    this.category = TodoCategory.other,
    this.priority = TodoPriority.medium,
    this.orderIndex = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isArchived = false,
    this.archivedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'category': category.index,
      'priority': priority.index,
      'orderIndex': orderIndex,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isArchived': isArchived ? 1 : 0,
      'archivedAt': archivedAt?.toIso8601String(),
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'].toString(),
      todoText: map['todoText'],
      category: TodoCategory.values[map['category'] ?? 3],
      priority: TodoPriority.values[map['priority'] ?? 1],
      orderIndex: map['orderIndex'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isArchived: map['isArchived'] == 1,
      archivedAt: map['archivedAt'] != null ? DateTime.parse(map['archivedAt']) : null,
    );
  }

  ToDo copyWith({
    String? id,
    String? todoText,
    TodoCategory? category,
    TodoPriority? priority,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    DateTime? archivedAt,
  }) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isArchived: isArchived ?? this.isArchived,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }
}

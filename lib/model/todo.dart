enum TodoPriority { high, medium, low }

enum AvoidType { generic, people, event, place }

enum CostType { money, mood, health, time, goodwill, patience }

class ToDo {
  String? id;
  String? todoText;
  List<String> tagIds;
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
  double? estimatedCost;
  CostType costType;

  // Avoid Types fields
  AvoidType avoidType;
  String? contactId;
  String? locationName;
  double? latitude;
  double? longitude;
  DateTime? reminderDateTime;

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
    this.costType = CostType.money,
    this.avoidType = AvoidType.generic,
    this.contactId,
    this.locationName,
    this.latitude,
    this.longitude,
    this.reminderDateTime,
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
      'costType': costType.index,
      'avoidType': avoidType.index,
      'contactId': contactId,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'reminderDateTime': reminderDateTime?.toIso8601String(),
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
      costType: map['costType'] != null
          ? CostType.values[map['costType']]
          : CostType.money,
      avoidType: map['avoidType'] != null
          ? AvoidType.values[map['avoidType']]
          : AvoidType.generic,
      contactId: map['contactId'],
      locationName: map['locationName'],
      latitude:
          map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      reminderDateTime: map['reminderDateTime'] != null
          ? DateTime.parse(map['reminderDateTime'])
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
    CostType? costType,
    AvoidType? avoidType,
    String? contactId,
    String? locationName,
    double? latitude,
    double? longitude,
    DateTime? reminderDateTime,
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
      costType: costType ?? this.costType,
      avoidType: avoidType ?? this.avoidType,
      contactId: contactId ?? this.contactId,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
    );
  }
}

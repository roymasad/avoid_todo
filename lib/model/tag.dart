import 'package:flutter/material.dart';

class Tag {
  final String id;
  final String name;
  final int colorValue; // stored as int (Color.value)
  final bool isBuiltIn;

  const Tag({
    required this.id,
    required this.name,
    required this.colorValue,
    this.isBuiltIn = false,
  });

  Color get color => Color(colorValue);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'color': colorValue,
        'isBuiltIn': isBuiltIn ? 1 : 0,
      };

  static Tag fromMap(Map<String, dynamic> map) => Tag(
        id: map['id'] as String,
        name: map['name'] as String,
        colorValue: map['color'] as int,
        isBuiltIn: map['isBuiltIn'] == 1,
      );

  Tag copyWith({String? id, String? name, int? colorValue, bool? isBuiltIn}) =>
      Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        colorValue: colorValue ?? this.colorValue,
        isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      );

  // Built-in default tags (migrate from old TodoCategory enum)
  static List<Tag> get builtIns => [
        const Tag(
            id: 'health',
            name: 'Health',
            colorValue: 0xFF4CAF50,
            isBuiltIn: true),
        const Tag(
            id: 'productivity',
            name: 'Productivity',
            colorValue: 0xFF5F52EE,
            isBuiltIn: true),
        const Tag(
            id: 'social',
            name: 'Social',
            colorValue: 0xFFFF9800,
            isBuiltIn: true),
        const Tag(
            id: 'other',
            name: 'Other',
            colorValue: 0xFF9E9E9E,
            isBuiltIn: true),
      ];

  // Preset palette for custom tags
  static const List<int> palette = [
    0xFFDA4040, // red
    0xFF4CAF50, // green
    0xFF5F52EE, // indigo
    0xFFFF9800, // orange
    0xFF00BCD4, // cyan
    0xFFE91E63, // pink
    0xFF795548, // brown
    0xFF607D8B, // blue-grey
    0xFF9C27B0, // purple
    0xFFFFEB3B, // yellow
  ];
}

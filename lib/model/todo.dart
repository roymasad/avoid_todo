class ToDo {
  String? id;
  String? todoText;

  ToDo({
    this.id,
    required this.todoText,

  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
    };
  }

  static ToDo fromMap(Map<String, dynamic> map) {
    return ToDo(
      id: map['id'].toString(),
      todoText: map['todoText'],
    );
  }
}
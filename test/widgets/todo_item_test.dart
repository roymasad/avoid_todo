import 'package:avoid_todo/model/todo.dart';
import 'package:avoid_todo/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('active todo keeps edit on row tap and uses break button',
      (WidgetTester tester) async {
    var editCount = 0;
    var breakCount = 0;
    final todo = ToDo(
      id: '1',
      todoText: 'Avoid ice cream',
      tagIds: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToDoItem(
            todo: todo,
            onEditItem: (_) => editCount++,
            onBreakItem: (_) => breakCount++,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Avoid ice cream'));
    await tester.pump();
    expect(editCount, 1);

    expect(find.byKey(const Key('todo_break_button')), findsOneWidget);
    expect(find.byKey(const Key('todo_edit_button')), findsNothing);

    await tester.tap(find.byKey(const Key('todo_break_button')));
    await tester.pump();
    expect(breakCount, 1);
  });

  testWidgets('archived todo keeps edit button', (WidgetTester tester) async {
    final todo = ToDo(
      id: '2',
      todoText: 'Old item',
      isArchived: true,
      tagIds: const [],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ToDoItem(
            todo: todo,
            onEditItem: (_) {},
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('todo_edit_button')), findsOneWidget);
    expect(find.byKey(const Key('todo_break_button')), findsNothing);
  });
}

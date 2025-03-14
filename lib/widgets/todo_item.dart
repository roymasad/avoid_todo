import 'package:flutter/material.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onDeleteItem;

  const ToDoItem({
    super.key,
    required this.todo,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          // print('Clicked on Todo Item.');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        title: Text(
          todo.todoText!,
          style: const TextStyle(
            fontSize: 18,
            color: tdBlack,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.thumb_up),
            onPressed: () {
              // print('Clicked on delete icon');
              onDeleteItem(todo.id);

              Fluttertoast.showToast(
                  msg: "Successfully Avoided !",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 22.0
              );
            },
          ),
        ),
      ),
    );
  }
}

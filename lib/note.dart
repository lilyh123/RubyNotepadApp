import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'note.g.dart';

TextEditingController contentController = TextEditingController();
TextEditingController titleController = TextEditingController();
bool lockedController = false;
TextEditingController passwordController = TextEditingController();
FocusNode textSecondFocusNode = FocusNode();

int noteTitleMaxLength = 25;
int noteContentMaxLine = 10;
int noteContentMaxLength = 25;
Note deletedNote = Note();

List<Color> noteColor = [
  Colors.orange.shade50,
];
List<Color> noteMarginColor = [
  Colors.orange.shade300,
];

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;
  @HiveField(1)
  String content;
  @HiveField(2)
  String date;
  @HiveField(3)
  bool locked;
  @HiveField(4)
  String password;

  Note(
      {this.title = "Note",
        this.content = "Text",
        this.date = "Date",
        this.locked = false,
        this.password = "Password"});
}

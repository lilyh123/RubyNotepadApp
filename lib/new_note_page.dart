import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'note.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({Key? key}) : super(key: key);

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  // var date = DateFormat("E, d MMM yyyy HH:mm").format(DateTime.now());
  // var date = DateFormat("yyyy/MM/dd (EEEE) HH:mm").format(DateTime.now());
  var date = DateTime.now();
  bool lockedState = false;

  late final Box box;

  @override
  void initState() {
    super.initState();
    noteContentMaxLength = noteContentMaxLine * noteContentMaxLine;
    titleController.clear();
    contentController.clear();
    passwordController.clear();
    box = Hive.box('notesBox');
  }

  _addInfo() async {
    Note newNote = Note(
      title: titleController.text,
      content: contentController.text,
      savedDate: date,
      locked: lockedState,
      password: passwordController.text,
    );
    box.add(newNote);
    print('Info added to box!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange.shade200,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            _promptSaveNote();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          TextButton(onPressed: _promptPassword, child: const Text("LOCK")),
          // GestureDetector(
          //   onTap: () {
          //     _promptPassword();
          //   },
          //   child: const Text("LOCK",),
          // )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(DateFormat("yyyy/MM/dd (EEEE) HH:mm").format(date))],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  maxLength: 35,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "Enter Title",
                  ),
                  controller: titleController,
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      expands: true,
                      maxLines: null,
                      controller: contentController,
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  void _promptSaveNote() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Are you sure?'),
              actions: <Widget>[
                TextButton(
                    child: const Text('Discard'),
                    onPressed: () {
                      setState(() {
                        titleController.clear();
                        contentController.clear();
                        passwordController.clear();
                      });

                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (titleController.text.isEmpty &&
                          contentController.text.isEmpty) {
                        print(
                            "note is not saved because both title and content were empty");
                      } else {
                        setState(() {
                          _addInfo();
                        });
                      }

                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    })
              ]);
        });
  }

  void _promptPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Please enter a password'),
              content: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                controller: passwordController,
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      setState(() {
                        passwordController.clear();
                      });

                      Navigator.of(context).pop();
                    }),
                TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (passwordController.text.isNotEmpty) {
                        lockedState = true;
                      } else {
                        print(
                            "password is not saved because both title and content were empty");
                      }

                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}

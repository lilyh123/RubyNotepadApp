import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'new_note_page.dart';
import 'note.dart';
import 'note_content.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  // var _formKey = GlobalKey<FormState>();

  late final Box box;

  @override
  void initState() {
    super.initState();
    noteContentMaxLength = noteContentMaxLine * noteContentMaxLine;
    box = Hive.box('notesBox');
    passwordController.clear();
  }

  @override
  void dispose() {
    contentController.dispose();
    titleController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _deleteInfo(int index) {
    box.deleteAt(index);
    print('Item deleted from box at index: $index');
  }

  _addInfo(Note n) async {
    box.add(n);
    print('Info added to box!');
  }

  // _checkDeletion() {
  //   DateTime curr = DateTime.now();
  //   for (int i = 0; i < box.length; i++) {
  //     print(curr.difference(box.getAt(i).date.minute).inMinutes.toString());
  //     if (curr.difference(box.getAt(i).date.minute).inMinutes >= 1) {
  //       _deleteInfo(i);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange.shade200,
        elevation: 0,
        title: const Text("Notes"),
      ),
      body: box.isNotEmpty
          ? buildNotes()
          : const Center(
        child: Text("Add Notes 😃"),
      ),
      floatingActionButton: FloatingActionButton(
        mini: false,
        backgroundColor: Colors.orange.shade200,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewNoteScreen()))
              .then((value) => setState(() {}));
        },
        child: const Icon(Icons.create),
      ),
    );
  }

  Widget buildNotes() {
    return Scaffold(
      body: ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, int index) {
          var noteInfo = box.getAt(index);
          return ListTile(
              contentPadding: const EdgeInsets.only(left: 10, right: 10),
              onTap: () {
                print("The item is clicked $index");
                if (noteInfo.locked == true) {
                  _promptPassword(index);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteContentScreen(index)),
                  ).then((value) => setState(() {}));
                }
              },
              title: Container(
                margin: const EdgeInsets.only(top: 5),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      deletedNote = noteInfo;
                      _deleteInfo(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Note Deleted",
                                style: TextStyle(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("undo");
                                  setState(() {
                                    _addInfo(deletedNote);
                                  });
                                },
                                child: const Text(
                                  "Undo",
                                  style: TextStyle(),
                                ),
                              )
                              // : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                  background: ClipRRect(
                    borderRadius: BorderRadius.circular(5.5),
                    child: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Text(
                                "Delete",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: noteList(index),
                ),
              ));
        },
      ),
    );
  }

  Widget noteList(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(5.5),
        ),
        height: 80,
        child: Center(
          child: Row(
            children: [
              Container(
                color: Colors.orange.shade300,
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 10, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (box.getAt(index).locked == true) ...[
                        Flexible(
                          child: Text(
                            '${box.getAt(index).title}🔒',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20.00,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ] else ...[
                        Flexible(
                          child: Text(
                            box.getAt(index).title.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20.00,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Flexible(
                          child: SizedBox(
                            height: double.infinity,
                            child:
                            AutoSizeText(
                              (box.getAt(index).content.toString()),
                              // (noteContentList[index]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15.00,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _promptPassword(int index) {
    passwordController.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Please enter the password'),
              content: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter password",
                  border: OutlineInputBorder(
                    // borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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
                    child: const Text('Enter'),
                    onPressed: () {
                      if (passwordController.text ==
                          box.getAt(index).password.toString()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteContentScreen(index)),
                        ).then((value) => Navigator.of(context).pop());
                      } else {
                        Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          message: "Wrong password",
                          icon: const Icon(
                            Icons.info_outline,
                            size: 28.0,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 2),
                          leftBarIndicatorColor: Colors.white,
                        ).show(context);
                      }
                      // Navigator.of(context).pop();
                    })
              ]);
        });
  }
}

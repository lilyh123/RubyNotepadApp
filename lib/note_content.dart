import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'note.dart';

class NoteContentScreen extends StatefulWidget {
  int index;

  NoteContentScreen(this.index, {Key? key}) : super(key: key);

  @override
  State<NoteContentScreen> createState() => _NoteContentScreenState();
}

class _NoteContentScreenState extends State<NoteContentScreen> {
  late int idx;

  // var date = DateFormat("E, d MMM yyyy HH:mm").format(DateTime.now());
  // var date = DateFormat("yyyy/MM/dd (EEEE) HH:mm").format(DateTime.now());
  var date = DateTime.now();
  late bool lockedState;

  late final Box box;

  @override
  void initState() {
    super.initState();
    noteContentMaxLength = noteContentMaxLine * noteContentMaxLine;
    passwordController.clear();
    box = Hive.box('notesBox');
    idx = widget.index;
    lockedState = box.getAt(idx).locked;
  }

  _updateInfo() {
    Note newNote = Note(
      title: titleController.text,
      content: contentController.text,
      savedDate: date,
      locked: lockedState,
      password: passwordController.text,
    );
    box.putAt(idx, newNote);
    setState(() {});
    print('Info updated in box!');
  }

  _deleteInfo(int index) {
    box.deleteAt(index);
    print('Item deleted from box at index: $index');
  }

  @override
  Widget build(BuildContext context) {
    idx = widget.index;
    var noteInfo = box.getAt(idx);

    titleController = TextEditingController(text: noteInfo.title);
    contentController = TextEditingController(text: noteInfo.content);
    passwordController = TextEditingController(text: noteInfo.password);

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
          // IconButton(
          //     onPressed: () async {
          //       final font = await PdfGoogleFonts.nunitoExtraLight();
          //       final pdf = pw.Document();
          //       pdf.addPage(pw.Page(
          //           pageFormat: PdfPageFormat.legal,
          //           build: (pw.Context context) {
          //             return pw.Center(
          //               child: pw.Text(noteInfo.title + "\n" + noteInfo.content,
          //                   style: pw.TextStyle(font: font)),
          //             );
          //           }
          //       ));
          //       String filename = "${DateFormat("yyyy-MM-dd").format(date)}.pdf";
          //       final output = await getTemporaryDirectory();
          //       print("the path is: " + output.path);
          //       final file = File("${output.path}/$filename.pdf");
          //       pdf.save();
          //       await file.writeAsBytes(await pdf.save());
          //     }, icon: const Icon(Icons.ios_share)
          // ),
          if (noteInfo.locked == true) ...[
            TextButton(
                onPressed: () {
                  lockedState = false;
                  noteInfo.locked = false;
                  _updateInfo();
                  setState(() {});
                },
                child: const Text("Remove Lock")),
          ] else ...[
            TextButton(
                onPressed: () {
                  _promptPassword();

                },
                child: Text("LOCK")),
          ]
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
                  children: [
                    Text(DateFormat("yyyy/MM/dd (EEEE) HH:mm").format(noteInfo.savedDate)),
                    // Text(noteDateList[idx].toString())
                  ],
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

                      // Navigator.of(context).pop();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (titleController.text.isEmpty &&
                          contentController.text.isEmpty) {
                        _deleteInfo(idx);
                      } else {
                        setState(() {
                          _updateInfo();
                        });
                      }
                      // Navigator.of(context).pop();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ]);
        });
  }

  void _promptPassword() {
    passwordController.clear();
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
                      print('password: ' + passwordController.text);
                      if (passwordController.text.isNotEmpty) {
                        lockedState = true;
                        _updateInfo();
                        Navigator.of(context).pop();
                      }
                      else {
                        Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          message: "Not saved. Password is required",
                          icon: const Icon(
                            Icons.info_outline,
                            size: 28.0,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 2),
                          leftBarIndicatorColor: Colors.white,
                        ).show(context).then((value) => Navigator.of(context).pop());
                      }

                    })
              ]);
        });
  }
}

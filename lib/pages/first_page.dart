import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/components/my_dismissible.dart';

import 'package:crud/components/my_textbutton.dart';
import 'package:crud/services/firestore.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final FirestoreService firestoreService = FirestoreService();
  final List<String> notes = [];
  final textControl1 = TextEditingController();
  void onDismissed(doc) {
    firestoreService.deleteNote(doc);
  }

  void onTap(BuildContext context, {String? docId}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text(
            'Create note',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          actions: [
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 56, 55, 55),
                    filled: true,
                    hintText: 'Enter the note',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  controller: textControl1,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextbutton(
                        text: 'Create',
                        onPressed: () {
                          if (docId == null) {
                            setState(() {
                              firestoreService.addNote(textControl1.text);
                              notes.add(textControl1.text.trim());
                              textControl1.clear();
                              Navigator.pop(context);
                            });
                          } else {
                            setState(() {
                              firestoreService.updateNote(
                                docId,
                                textControl1.text,
                              );

                              textControl1.clear();
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextbutton(
                        text: 'Cancle',
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(195, 68, 68, 67),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        onPressed: () {
          onTap(context);
        },
        child: Icon(Icons.add, size: 26, color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 80, 80),
        title: Text(
          'N O T E S',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = noteList[index];
                String doc = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                return Dismissible(
                  key: Key(doc),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    firestoreService.deleteNote(doc);

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Note deleted")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          noteText,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      trailing: SizedBox(
                        width: 130,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 70.0),
                              child: IconButton(
                                onPressed: () {
                                  onTap(context, docId: doc);
                                },
                                icon: Icon(Icons.settings),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text(
              'Enter Tour notes',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}

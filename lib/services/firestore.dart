import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = notes
        .orderBy('timestamp', descending: true)
        .snapshots();
    return notesStream;
  }

  Future<void> updateNote(String id, String newNote) {
    return notes.doc(id).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }
  Future<void> deleteNote(String id)
  {
    return notes.doc(id).delete();
  }
  
}

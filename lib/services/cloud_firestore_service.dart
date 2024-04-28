import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreService {
  final FirebaseFirestore db;

  const CloudFirestoreService(this.db);

  Future<String> add(Map<String, dynamic> data) async {
    final document = await db.collection('user').add(data);
    await db.collection('user').doc(document.id).update({'id': document.id});
    return document.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStatus() {
    return db.collection('status').snapshots();
  }

  Stream<List<Map<String, dynamic>>> streamUserData() {
    return db.collection('user').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Future<void> edit(String documentId, Map<String, dynamic> newData) async {
    await db.collection('user').doc(documentId).update(newData);
  }

  Future<void> delete(String documentId) async {
    await db.collection('user').doc(documentId).delete();
  }
}

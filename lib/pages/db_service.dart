import 'package:cloud_firestore/cloud_firestore.dart';

class DB_Service {
  final db = FirebaseFirestore.instance;

  Future<void> create(String uid, String card_name, int length) async {
    length += 1;
    await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(card_name)
        .set({
      'card_id': length,
    });
    print('create関数が動いています');
  }

  Future<List> read(String uid) async {
    final doc = await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .orderBy('card_id')
        .get();
    final documents = doc.docs.map((d) => d.id).toList();
    return documents;
  }

  Future<void> update() async {}
  Future<void> delete() async {}
}

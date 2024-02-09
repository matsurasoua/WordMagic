import 'package:cloud_firestore/cloud_firestore.dart';

class DB_Service {
  final db = FirebaseFirestore.instance;

  Future<String> readuser(String uid) async {
    final doc = await db.collection('users').doc(uid).get();
    print('read関数が動いています');
    final userinfo = doc.data()?['email'];
    return userinfo;
  }

  Future<void> create(String uid, String card_name, int length) async {
    length += 1;
    await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(card_name)
        .set({'card_id': length});
    print('create関数が動いています');
  }

  Future<List> read(String uid) async {
    final doc = await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .orderBy('card_id', descending: true)
        .get();
    print('read関数が動いています');
    final documents = doc.docs.map((d) => d.id).toList();
    return documents;
  }

  Future<void> update(String uid, String card_name, String update_card) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(card_name);
    await docRef.update({
      'id': update_card,
    });
    print('update関数が動いています');
  }

  Future<void> delete(String uid, String card) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(card)
        .delete();
  }

  Future<void> createglaph(String uid, String value) async {
    await db.collection('users').doc(uid).set({'goaltime': value});
    print('create関数が動いています');
  }
}

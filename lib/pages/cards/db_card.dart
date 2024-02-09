import 'package:cloud_firestore/cloud_firestore.dart';

class DB_Card {
  final db = FirebaseFirestore.instance;
  Future<void> create(String front_word, String back_word, String comment_word,
      String uid, String title, int length) async {
    length += 1;
    print(front_word);
    print(back_word);
    print(comment_word);
    print(uid);
    print(title);
    print(length);

    await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(title)
        .collection('datas')
        .doc(length.toString())
        .set({
      'card_id': length,
      'front_word': front_word,
      'back_word': back_word,
      'comment_word': comment_word,
    });
    print('create関数が動いています');
  }

  Future<List> read(String uid, String title) async {
    final doc = await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(title)
        .collection('datas')
        .get();
    print('read関数が動いています');
    final documents = doc.docs.map((d) => d.data()).toList();
    return documents;
  }

  Future<void> update(String front_word, String back_word, String comment_word,
      String uid, String title, int i) async {
    i += 1;
    print(front_word);
    print(i.toString());
    print(uid);
    print(title);
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(title)
        .collection('datas')
        .doc(i.toString());
    await docRef.update({
      'front_word': front_word,
      'back_word': back_word,
      'comment_word': comment_word,
    });
    print('update関数が動いています');
  }

  Future<void> delete(String uid, String card, int i) async {
    i += 1;
    await db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(card)
        .collection('datas')
        .doc(i.toString())
        .delete();
  }
}

import 'package:flutter/material.dart';
import 'package:word_magic/pages/cards/card_api.dart';
import 'package:word_magic/pages/cards/cards.dart';
import 'package:word_magic/pages/cards/db_card.dart';
import 'package:word_magic/setting/setting_color.dart';

class CardEditPage extends StatefulWidget {
  const CardEditPage(
      {super.key,
      required this.front_word,
      required this.back_word,
      required this.comment_word,
      required this.i,
      required this.uid,
      required this.title});
  final String front_word;
  final String back_word;
  final String comment_word;
  final int i;
  final String uid;
  final String title;

  @override
  State<CardEditPage> createState() => _CardEditPageState();
}

class _CardEditPageState extends State<CardEditPage> {
  String front_word = '';
  String back_word = '';
  String comment_word = '';
  final db_card = DB_Card();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 70, right: 15),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Color(Setting_Color.setting_gray),
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 70, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                title: Center(
                                  child: Text(
                                    '本当に削除しますか？',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                content: Container(
                                  width: 250,
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      widget.front_word + 'を削除する',
                                    ),
                                  ),
                                ),
                                actions: [
                                  Container(
                                    margin: EdgeInsets.only(right: 37),
                                    child: TextButton(
                                      child: Text(
                                        '削除',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(
                                                Setting_Color.setting_red),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        db_card.delete(
                                            widget.uid, widget.title, widget.i);
                                        // ダイアログを閉じる
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CardsPage(
                                              title: widget.title,
                                              uid: widget.uid,
                                            ),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: TextButton(
                                      child: Text(
                                        'キャンセル',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        // ダイアログを閉じる
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 30,
                          color: Color(Setting_Color.setting_red),
                        ),
                      )),
                ),
              ],
            ),
            Container(
              child: Text(
                'カード編集',
                style: TextStyle(
                    color: Color(Setting_Color.setting_blue),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      '表面',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 55),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
                      controller:
                          TextEditingController(text: widget.front_word),
                      maxLength: 36,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(Setting_Color.setting_blue),
                            width: 2.0,
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Color(Setting_Color.setting_gray),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(Setting_Color.setting_blue),
                            width: 1.0,
                          ),
                        ),
                      ),
                      onChanged: (String value) {
                        front_word = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Text(
                '裏面',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextFormField(
                  controller: TextEditingController(text: widget.back_word),
                  maxLines: 3,
                  maxLength: 68,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Color(Setting_Color.setting_blue),
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Color(Setting_Color.setting_gray),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Color(Setting_Color.setting_blue),
                        width: 1.0,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    back_word = value;
                  },
                )),
            Container(
              child: Text(
                'コメント',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextFormField(
                controller: TextEditingController(text: widget.comment_word),
                maxLines: 3,
                maxLength: 66,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(Setting_Color.setting_blue),
                      width: 2.0,
                    ),
                  ),
                  labelStyle: TextStyle(
                    fontSize: 15,
                    color: Color(Setting_Color.setting_gray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Color(Setting_Color.setting_blue),
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (String value) {
                  comment_word = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 70),
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(Setting_Color.setting_blue),
                  ),
                  child: Text(
                    '作成',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    print('カード作成ボタン押下');
                    if (front_word == '') front_word = widget.front_word;
                    if (back_word == '') back_word = widget.back_word;
                    if (comment_word == '') comment_word = widget.comment_word;
                    await db_card.update(
                      front_word,
                      back_word,
                      comment_word,
                      widget.uid,
                      widget.title,
                      widget.i,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

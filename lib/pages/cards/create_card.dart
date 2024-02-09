import 'package:flutter/material.dart';
import 'package:word_magic/pages/cards/card_api.dart';
import 'package:word_magic/pages/cards/db_card.dart';
import 'package:word_magic/setting/setting_color.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage(
      {super.key,
      required this.title,
      required this.uid,
      required this.length});
  final String title;
  final String uid;
  final int length;

  @override
  State<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  String front_word = '';
  String back_word = '';
  String comment_word = '';
  String errorMessage = '表面が未入力なのでAIモードが使えません';
  final db_card = DB_Card();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      body: SingleChildScrollView(
        child: Column(
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
              child: Text(
                'カード作成',
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
                Container(
                  margin: EdgeInsets.only(top: 3, right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, right: 7),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'AI解説',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(Setting_Color.setting_red),
                                ),
                              ),
                              TextSpan(
                                text: 'モード',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // width: 45,
                        // height: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(Setting_Color.setting_blue),
                                offset: Offset(0, 0),
                                blurRadius: 1,
                                spreadRadius: 1,
                              )
                            ]),
                        child: IconButton(
                          onPressed: () async {
                            print(front_word);
                            if (front_word == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                ),
                              );
                            } else {
                              var ai_text =
                                  await card_api().fetchData(front_word);
                              // '人工知能（AI）の開発に適しており、データの収集やデータ分析などにも強いプログラミング言語';
                              // await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                back_word = ai_text.toString();
                                // print(back_word);
                              });
                            }
                          },
                          icon: Icon(
                            Icons.smart_toy,
                            color: Color(Setting_Color.setting_blue), // Iconの色
                            size: 30, // Iconのサイズ
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 55),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextFormField(
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
                  controller: TextEditingController(text: back_word),
                  maxLines: 3,
                  // maxLength: 68,
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
                    await db_card.create(front_word, back_word, comment_word,
                        widget.uid, widget.title, widget.length);
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

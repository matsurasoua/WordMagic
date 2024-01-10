import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/db_service.dart';
import 'package:word_magic/pages/home.dart';
import 'package:word_magic/pages/main.dart';
import 'package:word_magic/pages/signup.dart';
import 'package:word_magic/setting/setting_color.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  String card_name = '';
  String errorMessage = '未入力です。';
  final auth = FirebaseAuth.instance;
  // 現在ログイン中のユーザID
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final db_service = DB_Service();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('cards')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.size;
          if (count > 0) {
            // ドキュメントが１個以上の場合
            return yesdata(count);
          } else {
            // ドキュメントが０個の場合
            return nodata();
          }
        } else {
          // データの取得中の表示ロード画面
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  // データが入っている時
  Widget yesdata(int count) {
    return FutureBuilder<List>(
        future: db_service.read(uid!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cards = snapshot.data!;
            print(cards[0]);
            print(cards.length);
            print(count);
            return Scaffold(
              backgroundColor: Color(Setting_Color.setting_background),
              // AppBar
              appBar: AppBar(
                centerTitle: false,
                title: Image.asset(
                  'assets/wordmagic_word_result.png',
                  width: 170,
                ),
                actions: [
                  IconButton(
                      // 検索ボタン
                      onPressed: () {
                        db_service.read(uid!);
                        // ログアウト処理
                        auth.signOut().then((_) async {
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return MyApp();
                            }),
                          );
                        }).catchError((error) {
                          // ログアウト失敗
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        color: Color(Setting_Color.setting_gray),
                        size: 33,
                      )),
                  IconButton(
                      // 編集ボタン
                      onPressed: () {
                        db_service.read(uid!);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Color(Setting_Color.setting_gray),
                        size: 33,
                      )),
                ],
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 30),
                        child: Text('単語帳一覧',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    for (int i = 0; i < count; i++) ...{
                      Container(
                        child: Stack(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 30, left: 30, right: 30),
                              child: Text(
                                i.toString(),
                                // cards[i],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(Setting_Color.setting_gray)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Icon(Icons.navigate_next),
                              ),
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(top: 30),
                        width: 350,
                        height: 90,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // 影の位置（x, y）
                              ),
                            ],
                            border: Border.all(
                                color: Color(setting_blue), width: 2.0)),
                      ),
                    },
                    // 下の余白
                    Container(
                      margin: EdgeInsets.only(top: 75),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Color(setting_blue),
                label: Text('単語帳作成',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Color(Setting_Color.setting_background),
                      isScrollControlled:
                          true, //trueにしないと、Containerのheightが反映されない
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Column(
                            children: [
                              // 閉じるボタン
                              Container(
                                margin: EdgeInsets.only(top: 15, right: 15),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.cancel_outlined,
                                        size: 30,
                                        color:
                                            Color(Setting_Color.setting_gray),
                                      ),
                                    )),
                              ),
                              // 新しい単語帳を作成テキスト
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text('新しい単語帳を作成',
                                    style: TextStyle(
                                        color:
                                            Color(Setting_Color.setting_gray),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 27)),
                              ),
                              Container(
                                width: 300,
                                margin: EdgeInsets.only(top: 30),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color:
                                            Color(Setting_Color.setting_blue),
                                        width: 2.0,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color(Setting_Color.setting_gray),
                                    ),
                                    labelText: '新規単語帳名',
                                    floatingLabelStyle: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color(Setting_Color.setting_blue)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color:
                                            Color(Setting_Color.setting_blue),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  onChanged: (String value) {
                                    card_name = value;
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
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Color(Setting_Color.setting_blue),
                                    ),
                                    child: Text(
                                      '作成',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () async {
                                      try {
                                        // 単語帳作成
                                        await db_service.create(
                                          // ユーザIDと単語帳名
                                          uid!,
                                          card_name,
                                          cards.length,
                                        );
                                        Navigator.of(context).pop(HomePage());
                                      } catch (_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  // データが入っていない時
  Widget nodata() {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      // AppBar
      appBar: AppBar(
        centerTitle: false,
        title: Image.asset(
          'assets/wordmagic_word_result.png',
          width: 170,
        ),
        actions: [
          IconButton(
              // 単語カード作成ボタン
              onPressed: () {
                db_service.read(uid!);
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.indigoAccent,
                size: 30,
              )),
        ],
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 180, right: 15),
              child: Image.asset(
                'assets/card_white.png',
                width: 250,
                height: 150,
              ),
            ),
            Container(
              child: Text(
                '単語帳を作成しましょう！',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(Setting_Color.setting_gray)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                '右下のボタンを押して単語帳を作成してみましょう！',
                style: TextStyle(
                    fontSize: 13, color: Color(Setting_Color.setting_gray)),
              ),
            ),
            Container(
              child: Text('作成した単語帳の中にカードを作成できます。',
                  style: TextStyle(
                      fontSize: 13, color: Color(Setting_Color.setting_gray))),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(Setting_Color.setting_blue),
        label: Text('単語帳作成',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Color(Setting_Color.setting_background),
              isScrollControlled: true, //trueにしないと、Containerのheightが反映されない
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: [
                      // 閉じるボタン
                      Container(
                        margin: EdgeInsets.only(top: 15, right: 15),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                size: 30,
                                color: Color(Setting_Color.setting_gray),
                              ),
                            )),
                      ),
                      // 新しい単語帳を作成テキスト
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Text('新しい単語帳を作成',
                            style: TextStyle(
                                color: Color(Setting_Color.setting_gray),
                                fontWeight: FontWeight.bold,
                                fontSize: 27)),
                      ),
                      Container(
                        width: 300,
                        margin: EdgeInsets.only(top: 30),
                        child: TextFormField(
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
                            labelText: '新規単語帳名',
                            floatingLabelStyle: TextStyle(
                                fontSize: 20,
                                color: Color(Setting_Color.setting_blue)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Color(Setting_Color.setting_blue),
                                width: 1.0,
                              ),
                            ),
                          ),
                          onChanged: (String value) {
                            card_name = value;
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Color(Setting_Color.setting_blue),
                            ),
                            child: Text(
                              '作成',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              try {
                                // 単語帳作成
                                db_service.create(uid!, card_name, 0);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }),
                                );
                              } catch (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}

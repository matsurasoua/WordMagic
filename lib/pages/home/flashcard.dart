import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/cards/cards.dart';
import 'package:word_magic/pages/home/db_service.dart';
import 'package:word_magic/pages/home/home.dart';
import 'package:word_magic/pages/auth/main.dart';
import 'package:word_magic/pages/auth/signup.dart';
import 'package:word_magic/setting/setting_color.dart';

class FlashCardPage extends StatefulWidget {
  const FlashCardPage({super.key});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  // 単語帳名
  String card_name = '';
  String nowcard = '';
  String update_card = '';
  // エラーメッセージ
  String errorMessage = '未入力です。';
  // 削除完了表示
  String delete_text = '単語帳を削除しました。';
  // カウント
  int count = 0;
  // editの状態
  bool isEdited = true;
  // 検索の状態
  bool isSearch = true;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
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
            backgroundColor: Color(setting_background),
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
            print(cards);
            return Scaffold(
              backgroundColor: Color(Setting_Color.setting_background),
              // AppBar
              appBar: AppBar(
                  centerTitle: true,
                  title: isSearch
                      ? Image.asset(
                          'assets/wordmagic_word_result.png',
                          width: 170,
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 35),
                          child: TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16)),
                          ),
                        ),
                  actions: [
                    IconButton(
                        // 検索ボタン
                        onPressed: () {
                          setState(() {
                            isSearch = !isSearch;
                          });
                        },
                        icon: isSearch
                            ? Icon(
                                Icons.search,
                                color: Color(Setting_Color.setting_gray),
                                size: 33,
                              )
                            : Icon(
                                Icons.close,
                                color: Color(Setting_Color.setting_gray),
                                size: 28,
                              )),
                    IconButton(
                        // 編集ボタン
                        onPressed: () {
                          setState(() {
                            // 状態切り替え
                            isEdited = !isEdited;
                          });
                        },
                        icon: Icon(
                          // trueなら編集ボタン、falseならチェックボタン
                          isEdited ? Icons.delete_outline : Icons.check,
                          color: isEdited
                              ? Color(Setting_Color.setting_red)
                              : Color(Setting_Color.setting_green),
                          size: 33,
                        )),
                  ],
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  iconTheme: IconThemeData(
                      color: Color(Setting_Color.setting_gray), size: 30)),
              drawer: Drawer(
                backgroundColor: Color(setting_background),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(color: Color(setting_blue)),
                        child: Image.asset('assets/splash.png')),
                    Container(
                      child: ListTile(
                        title: Text(
                          'ecc@ecc.ac.jp',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        // subtitle: Text('ecc@ecc.ac.jp'),
                        leading: const Icon(Icons.mail),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 400),
                      child: ListTile(
                        title: Text(
                          'Logout',
                          style: TextStyle(fontSize: 20),
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: Color(Setting_Color.setting_red),
                        ),
                        onTap: () {
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
                      ),
                    )
                  ],
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {});
                },
                child: SingleChildScrollView(
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
                      for (int i = 0; i < cards.length; i++) ...{
                        // not編集モード
                        if (isEdited) ...{
                          GestureDetector(
                            onTap: () {
                              // 画面遷移処理
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardsPage(
                                    title: cards[i],
                                    uid: uid!,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 30, left: 35, right: 30),
                                    child: Text(
                                      cards[i],
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color(Setting_Color.setting_gray),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        Icons.navigate_next,
                                        color:
                                            Color(Setting_Color.setting_gray),
                                      ),
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
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 1.3,
                                    blurRadius: 1,
                                    offset: Offset(0, 1.5), // 影の位置（x, y）
                                  ),
                                ],
                                border: Border.all(
                                    color: Color(setting_blue), width: 2.0),
                              ),
                            ),
                          ),
                        } else ...{
                          // 編集モード
                          GestureDetector(
                            onTap: () {
                              if (!isEdited) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      insetPadding: EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
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
                                            cards[i] + 'を削除する',
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
                                                  color: Color(Setting_Color
                                                      .setting_red),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              db_service.delete(uid!, cards[i]);
                                              // ダイアログを閉じる
                                              Navigator.of(context).pop();
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
                              }
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 30, left: 35, right: 30),
                                    child: Text(
                                      cards[i],
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color(Setting_Color.setting_gray),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 12),
                                      child: Icon(
                                        isEdited
                                            ? Icons.navigate_next
                                            : Icons.delete_outline,
                                        size: 30,
                                        color: isEdited
                                            ? Color(Setting_Color.setting_gray)
                                            : Color(Setting_Color.setting_red),
                                      ),
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
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 1.3,
                                    blurRadius: 1,
                                    offset: Offset(0, 1.5), // 影の位置（x, y）
                                  ),
                                ],
                                border: Border.all(
                                    color: Color(Setting_Color.setting_red),
                                    width: 2.0),
                              ),
                            ),
                          )
                        }
                      },
                      // 下の余白
                      Container(
                        margin: EdgeInsets.only(top: 75),
                      )
                    ],
                  ),
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
                                      Icons.close,
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
                                maxLength: 12,
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
                              child: Text(
                                '一度作成すると変更できません。',
                                style: TextStyle(
                                    color: Color(Setting_Color.setting_red)),
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
                                          cards.length);
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
                    },
                  );
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
          centerTitle: true,
          title: Image.asset(
            'assets/wordmagic_word_result.png',
            width: 170,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          iconTheme: IconThemeData(
              color: Color(Setting_Color.setting_gray), size: 30)),
      drawer: Drawer(
        backgroundColor: Color(setting_background),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Color(setting_blue)),
                child: Image.asset('assets/splash.png')),
            Container(
              child: ListTile(
                title: Text(
                  'ecc@ecc.ac.jp',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                // subtitle: Text('ecc@ecc.ac.jp'),
                leading: const Icon(Icons.mail),
                onTap: () {},
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 400),
              child: ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Color(Setting_Color.setting_red),
                ),
                onTap: () {
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
              ),
            )
          ],
        ),
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
                              Icons.close,
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
                        maxLength: 12,
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
                      child: Text(
                        '一度作成すると変更できません。',
                        style:
                            TextStyle(color: Color(Setting_Color.setting_red)),
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
                            backgroundColor: Color(Setting_Color.setting_blue),
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
                                  0);
                              Navigator.of(context).pop(HomePage());
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
            },
          );
        },
      ),
    );
  }
}

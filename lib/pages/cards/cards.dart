import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:word_magic/pages/cards/card_api.dart';
import 'package:word_magic/pages/cards/create_card.dart';
import 'package:word_magic/pages/cards/db_card.dart';
import 'package:word_magic/setting/setting_color.dart';
import 'package:flip_card/flip_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key, required this.title, required this.uid});
  final String title;
  final String uid;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  String front_word = '';
  String back_word = '';
  String comment_word = '';
  final db_card = DB_Card();
  final api = card_api();
  bool _isLongPressed = false;
  int num = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .collection('cards')
          .doc(widget.title)
          .collection('datas')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int count = snapshot.data!.size;
          if (count > 0) {
            // ドキュメントが１個以上の場合
            return yesdata();
          } else {
            // ドキュメントが０個の場合
            return nodata();
          }
        } else {
          // データの取得中の表示ロード画面
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(Setting_Color.setting_gray),
                ),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            backgroundColor: Color(Setting_Color.setting_background),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  // データあり
  Widget yesdata() {
    return FutureBuilder<List>(
      future: db_card.read(widget.uid, widget.title),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cards = snapshot.data;
          final List<String> items = [];
          for (int i = 0; i < cards!.length; i++) {
            items.add(cards[i]['comment_word']);
          }
          return Scaffold(
            backgroundColor: Color(Setting_Color.setting_background),
            // AppBar
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.close),
                color: Color(
                  Setting_Color.setting_gray,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                Container(
                  child: IconButton(
                    onPressed: () async {
                      print('編集ボタン押下');
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Color(Setting_Color.setting_gray),
                      size: 25,
                    ),
                  ),
                ),
              ],
              title: Text(
                widget.title,
                style: TextStyle(
                    color: Color(Setting_Color.setting_blue),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 240),
                  child: CarouselSlider(
                    items: [
                      for (int i = 0; i < cards.length; i++) ...{
                        Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, bottom: 10, top: 15),
                          child: FlipCard(
                            fill: Fill.fillBack,
                            direction: FlipDirection.HORIZONTAL,
                            // 表面
                            front: Container(
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
                                    color: Color(Setting_Color.setting_blue),
                                    width: 1.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(15),
                                child: Center(
                                    child: Text(
                                  cards[i]['front_word'],
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            // 裏面
                            back: Container(
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
                                border:
                                    Border.all(color: Colors.black, width: 1.0),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    child: Center(
                                      child: Text(
                                        cards[i]['back_word'],
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: GestureDetector(
                                        onTapDown: (_) {
                                          setState(() {
                                            _isLongPressed = true;
                                            print(_isLongPressed);
                                            num = i;
                                            print(num);
                                          });
                                        },
                                        onTapUp: (_) {
                                          setState(() {
                                            _isLongPressed = false;
                                            print(_isLongPressed);
                                          });
                                        },
                                        child: Icon(
                                          _isLongPressed
                                              ? Icons.lightbulb_circle
                                              : Icons.lightbulb_circle_outlined,
                                          size: 45,
                                          color: Color(
                                            Setting_Color.setting_blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      },
                    ],
                    options: CarouselOptions(
                      height: 200, //高さ
                      initialPage: 0, //最初に表示されるページ
                      autoPlay: false, //自動でスライドしてくれるか
                      viewportFraction: 0.91, //各カードの表示される範囲の割合
                      enableInfiniteScroll: false, //最後のカードから最初のカードへの遷移
                    ),
                  ),
                ),
                if (_isLongPressed) ...{
                  if (items[num] != '') ...{
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 100),
                            width: 300,
                            height: 100,
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
                                  color: Color(Setting_Color.setting_blue),
                                  width: 1.0),
                            ),
                            child: Center(
                              child: Text(items[num]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  } else ...{
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 100),
                            width: 300,
                            height: 100,
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
                                  color: Color(Setting_Color.setting_blue),
                                  width: 1.0),
                            ),
                            child: Center(
                              child: Text(
                                'コメントがありません',
                                style: TextStyle(
                                    color: Color(Setting_Color.setting_red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  },
                }
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Color(Setting_Color.setting_blue),
              label: Text(
                'カード作成',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCardPage(
                      title: widget.title,
                      uid: widget.uid,
                      length: cards.length,
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // データなし
  Widget nodata() {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      // AppBar
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Color(Setting_Color.setting_gray),
          ),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
              color: Color(Setting_Color.setting_blue),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 200, right: 17),
              child: Image.asset(
                'assets/hatena_card.png',
                width: 200,
              ),
            ),
            Container(
              child: Text(
                'カードが無いようです...',
                style: TextStyle(
                    color: Color(Setting_Color.setting_gray),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text('右上の＋ボタンを押して追加してみましょう！',
                  style: TextStyle(
                      color: Color(Setting_Color.setting_gray), fontSize: 15)),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(Setting_Color.setting_blue),
        label: Text('カード作成',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCardPage(
                title: widget.title,
                uid: widget.uid,
                length: 0,
              ),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}

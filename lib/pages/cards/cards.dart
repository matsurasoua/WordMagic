import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/auth/signup.dart';
import 'package:word_magic/pages/cards/card_api.dart';
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
          print(widget.title);
          print(widget.uid);
          print(count);
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
            backgroundColor: Color(setting_background),
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
                actions: [
                  Container(
                      child: IconButton(
                          onPressed: () async {
                            String apia = await api.fetchData();
                            print(apia);
                            // showModalBottomSheet(
                            //     context: context,
                            //     backgroundColor:
                            //         Color(Setting_Color.setting_background),
                            //     isScrollControlled:
                            //         true, //trueにしないと、Containerのheightが反映されない
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.vertical(
                            //           top: Radius.circular(20)),
                            //     ),
                            //     builder: (BuildContext context) {
                            //       return Container(
                            //         height: MediaQuery.of(context).size.height *
                            //             0.85,
                            //         child: Column(
                            //           children: [
                            //             Container(
                            //               margin: EdgeInsets.only(
                            //                   top: 15, right: 15),
                            //               child: Align(
                            //                   alignment: Alignment.topRight,
                            //                   child: IconButton(
                            //                     onPressed: () {
                            //                       Navigator.pop(context);
                            //                     },
                            //                     icon: Icon(
                            //                       Icons.close,
                            //                       size: 30,
                            //                       color: Color(Setting_Color
                            //                           .setting_gray),
                            //                     ),
                            //                   )),
                            //             ),
                            //             Container(
                            //                 margin: EdgeInsets.only(top: 30),
                            //                 child: Text(
                            //                   'カード作成',
                            //                   style: TextStyle(
                            //                       color: Color(Setting_Color
                            //                           .setting_blue),
                            //                       fontSize: 22,
                            //                       fontWeight: FontWeight.bold),
                            //                 )),
                            //             Container(
                            //               child: Text('表面'),
                            //             ),
                            //             Container(
                            //                 // margin: EdgeInsets.only(top: 30),
                            //                 width: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.85,
                            //                 child: TextFormField(
                            //                   maxLength: 20,
                            //                   onChanged: (String value) {
                            //                     front_word = value;
                            //                   },
                            //                 )),
                            //             Container(
                            //               child: Text('裏面'),
                            //             ),
                            //             Container(
                            //                 // margin: EdgeInsets.only(top: 30),
                            //                 width: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.85,
                            //                 child: TextFormField(
                            //                   maxLength: 42,
                            //                   onChanged: (String value) {
                            //                     back_word = value;
                            //                   },
                            //                 )),
                            //             Container(
                            //               child: Text('コメント'),
                            //             ),
                            //             Container(
                            //                 // margin: EdgeInsets.only(top: 30),
                            //                 width: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.85,
                            //                 child: TextFormField(
                            //                   onChanged: (String value) {
                            //                     comment_word = value;
                            //                   },
                            //                 )),
                            //             Container(
                            //               margin: EdgeInsets.only(top: 70),
                            //               width: 180,
                            //               height: 40,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(10),
                            //               ),
                            //               child: Container(
                            //                 decoration: BoxDecoration(
                            //                     borderRadius:
                            //                         BorderRadius.circular(10)),
                            //                 child: ElevatedButton(
                            //                   style: ElevatedButton.styleFrom(
                            //                     foregroundColor: Colors.white,
                            //                     backgroundColor: Color(
                            //                         Setting_Color.setting_blue),
                            //                   ),
                            //                   child: Text(
                            //                     '作成',
                            //                     style: TextStyle(fontSize: 20),
                            //                   ),
                            //                   onPressed: () async {
                            //                     print('カード作成ボタン押下');
                            //                     await db_card.create(
                            //                         front_word,
                            //                         back_word,
                            //                         comment_word,
                            //                         widget.uid,
                            //                         widget.title,
                            //                         cards!.length);
                            //                     Navigator.of(context).pop();
                            //                   },
                            //                 ),
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       );
                            //     });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Color(Setting_Color.setting_gray),
                            size: 25,
                          ))),
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
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 150),
                    child: CarouselSlider(
                      items: [
                        for (int i = 0; i < cards!.length; i++) ...{
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
                                      fontWeight: FontWeight.bold
                                    ),
                                  )),
                                ),
                              ),
                              // 裏面
                              back: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF7F7F7),
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
                                        color: Colors.black, width: 1.0)),
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: Center(
                                      child: Text(
                                    cards[i]['back_word'],
                                    style: TextStyle(fontSize: 20),
                                  )),
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
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Color(Setting_Color.setting_blue),
                label: Text('カード作成',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Color(Setting_Color.setting_background),
                        isScrollControlled:
                            true, //trueにしないと、Containerのheightが反映されない
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10, right: 15),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          size: 30,
                                          color:
                                              Color(Setting_Color.setting_gray),
                                        ),
                                      )),
                                ),
                                Container(
                                    child: Text(
                                      'カード作成',
                                      style: TextStyle(
                                          color:
                                              Color(Setting_Color.setting_blue),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                  child: Text('表面',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.85,
                                   child: TextFormField(
                                  maxLength: 12,
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
                                    front_word = value;
                                  },
                                ),),
                                Container(
                                  child: Text('裏面',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.85,
                                   child: TextFormField(
                                    maxLines: 3,
                                  maxLength:35,
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
                                    front_word = value;
                                  },
                                )),
                                Container(
                                  child: Text('コメント',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.85,
                                   child: TextFormField(
                                    maxLines: 3,
                                  maxLength: 35,
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
                                    front_word = value;
                                  },
                                ),),
                                Container(
                                  margin: EdgeInsets.only(top: 70),
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        print('カード作成ボタン押下');
                                        await db_card.create(
                                            front_word,
                                            back_word,
                                            comment_word,
                                            widget.uid,
                                            widget.title,
                                            0);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                )
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
          actions: [
            Container(
              child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Color(Setting_Color.setting_background),
                        isScrollControlled:
                            true, //trueにしないと、Containerのheightが反映されない
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10, right: 15),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          size: 30,
                                          color:
                                              Color(Setting_Color.setting_gray),
                                        ),
                                      )),
                                ),
                                Container(
                                    
                                    child: Text(
                                      'カード作成',
                                      style: TextStyle(
                                          color:
                                              Color(Setting_Color.setting_blue),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                  child: Text('表面',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                    // margin: EdgeInsets.only(top: 30),
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: TextFormField(
                                      onChanged: (String value) {
                                        front_word = value;
                                      },
                                    )),
                                Container(
                                  child: Text('裏面',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                    // margin: EdgeInsets.only(top: 30),
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: TextFormField(
                                      onChanged: (String value) {
                                        back_word = value;
                                      },
                                    )),
                                Container(
                                  child: Text('コメント',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                Container(
                                    // margin: EdgeInsets.only(top: 30),
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: TextFormField(
                                      onChanged: (String value) {
                                        comment_word = value;
                                      },
                                    )),
                                Container(
                                  margin: EdgeInsets.only(top: 70),
                                  width: 180,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                                        print('カード作成ボタン押下');
                                        await db_card.create(
                                            front_word,
                                            back_word,
                                            comment_word,
                                            widget.uid,
                                            widget.title,
                                            0);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: Icon(
                    Icons.add,
                    color: Color(Setting_Color.setting_gray),
                    size: 25,
                  )),
            )
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
                        color: Color(Setting_Color.setting_gray),
                        fontSize: 15)),
              )
            ],
          ),
        ));
  }
}

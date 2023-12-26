import 'package:flutter/material.dart';
import 'package:word_magic/pages/signup.dart';
import 'package:word_magic/setting/setting_color.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  String card_name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      // AppBar
      appBar: AppBar(
        title: Text(
          'WordMagic',
          style: TextStyle(color: Colors.blue[900]),
        ),
        actions: [
          IconButton(
              // 単語カード作成ボタン
              onPressed: () {
                // // ログアウト処理
                // FirebaseAuth.instance.signOut().then((_) async {
                //   await Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) {
                //       return MyApp();
                //     }),
                //   );
                // }).catchError((error) {
                //   // ログアウト失敗
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text(error.toString()),
                //     ),
                //   );
                // });
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
                    fontSize: 19,
                    color: Color(Setting_Color.setting_gray)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                '右下のボタンを押して単語帳を作成してみましょう！',
                style: TextStyle(
                    fontSize: 12, color: Color(Setting_Color.setting_gray)),
              ),
            ),
            Container(
              child: Text('作成した単語帳の中にカードを作成できます。',
                  style: TextStyle(
                      fontSize: 12, color: Color(Setting_Color.setting_gray))),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(setting_blue),
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
                  height: MediaQuery.of(context).size.height * 0.5,
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
                        margin: EdgeInsets.only(top: 50),
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
                              print(card_name);
                              // try {
                              //   final FirebaseAuth auth =
                              //       FirebaseAuth.instance;
                              //   await auth.createUserWithEmailAndPassword(
                              //     email: email,
                              //     password: password,
                              //   );
                              //     MaterialPageRoute(builder: (context) {
                              //       return HomePage();
                              //     }),
                              //   );
                              //   // エラーメッセージ
                              // } catch (_) {
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(SnackBar(
                              //     content: Text(errorMessage),
                              //   ));
                              // }
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

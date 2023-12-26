import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/home.dart';
import '../setting/setting_color.dart';

Setting_Color setting_color = new Setting_Color();
var setting_blue = Setting_Color.setting_blue;
var setting_background = Setting_Color.setting_background;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';
  bool _isObscure = true;
  String errorMessage = '正しく入力してください';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(setting_blue),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Image.asset('assets/splash.png'),
                  width: 184,
                  height: 178,
                  margin: EdgeInsets.only(top: 50),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    topRight: Radius.circular(80.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Color(setting_background),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50, bottom: 50),
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Color(setting_blue),
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Color(Setting_Color.setting_gray),
                              ),
                              labelText: 'メールアドレス',
                              floatingLabelStyle: TextStyle(
                                  fontSize: 20, color: Color(setting_blue)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Color(setting_blue),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (String value) {
                              email = value;
                            },
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 27),
                          child: TextFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Color(setting_blue),
                                  width: 2.0,
                                ),
                              ),
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Color(Setting_Color.setting_gray),
                              ),
                              labelText: 'パスワード',
                              suffixIcon: IconButton(
                                // 文字の表示・非表示でアイコンを変える
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                // アイコンがタップされたら現在と反対の状態をセットする
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              floatingLabelStyle: TextStyle(
                                  fontSize: 20, color: Color(setting_blue)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Color(setting_blue),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            onChanged: (String value) {
                              password = value;
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
                                backgroundColor: Color(setting_blue),
                              ),
                              child: Text(
                                '登録',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                try {
                                  final FirebaseAuth auth =
                                      FirebaseAuth.instance;
                                  await auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  await Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                      return HomePage();
                                    }),
                                  );
                                  // エラーメッセージ
                                } catch (_) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(errorMessage),
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 180,
                          height: 40,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Color(setting_blue),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                                side: BorderSide(color: Color(setting_blue))),
                            child: Text(
                              '戻る',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

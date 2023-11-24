import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/home.dart';
import 'setting/setting_color.dart';

Setting_Color setting_color = new Setting_Color();
var setting_blue = Setting_Color.setting_blue;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 200),
                  child: Image.asset('assets/title_image_result-2.png'),
                  width: 300,
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color(0xffFFD852),
                          width: 2.0,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Color(setting_blue),
                      ),
                      labelText: 'メールアドレス',
                      floatingLabelStyle:
                          TextStyle(fontSize: 20, color: Color(setting_blue)),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Color(0xffFFD852),
                          width: 2.0,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Color(setting_blue),
                      ),
                      labelText: 'パスワード',
                      floatingLabelStyle:
                          TextStyle(fontSize: 20, color: Color(setting_blue)),
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
                  child: OutlinedButton(
                    child: Text('ログイン'),
                    onPressed: () async {
                      try {
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }),
                        );
                      } catch (e) {
                        print(e.toString());
                      }
                    },
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

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/home/home.dart';
import 'package:word_magic/pages/auth/signup.dart';
import '../../setting/setting_color.dart';

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
  String errorMessage = 'メールアドレスかパスワードが正しくありません';
  bool _isObscure = true;

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
                            'Login',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 20),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: "stuby@gmail"),
                            keyboardType: TextInputType.emailAddress,
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
                            obscureText: _isObscure,
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
                                color: Color(_isObscure
                                    ? Setting_Color.setting_gray
                                    : setting_blue),
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
                                'ログイン',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                UserLogin();
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
                              '新規登録',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SignupPage();
                              }));
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

  Future<void> UserLogin() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(user.user?.uid);
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }),
      );
    } on FirebaseAuthException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }
}

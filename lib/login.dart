import 'package:flutter/material.dart';
import 'setting/setting_color.dart';

Setting_Color setting_color = new Setting_Color();
var setting_blue = Setting_Color.setting_blue;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                // margin: EdgeInsets.only(top: 270),
                child: Image.asset('assets/title_image_result.png'),
                width: 300,
              ),
              Container(
                width: 300,
                margin: EdgeInsets.only(top: 40),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

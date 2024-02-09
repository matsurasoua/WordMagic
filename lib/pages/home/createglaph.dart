import 'package:flutter/material.dart';
import 'package:word_magic/pages/home/db_service.dart';
import 'package:word_magic/setting/setting_color.dart';

class CreateGlaphPage extends StatefulWidget {
  const CreateGlaphPage({
    super.key,
    required this.uid,
    required this.nowtime,
  });
  final String uid;
  final String nowtime;

  @override
  State<CreateGlaphPage> createState() => _CreateGlaphPageState();
}

class _CreateGlaphPageState extends State<CreateGlaphPage> {
  final db_service = DB_Service();
  String _selectedValue = '30';
  List<String> listmenu = [
    '30分',
    '60分',
    '90分',
    '120分',
    '150分',
    '180分',
    '210分',
    '240分',
    '270分',
    '300分'
  ];
  List<String> listvalue = [
    '30',
    '60',
    '90',
    '120',
    '150',
    '180',
    '210',
    '240',
    '270',
    '300'
  ];
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
                '目標時間設定',
                style: TextStyle(
                    color: Color(Setting_Color.setting_blue),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '現在の目標時間',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: widget.nowtime,
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(Setting_Color.setting_red))),
                    TextSpan(
                        text: '分',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 100, left: 50, right: 50),
              child: DropdownButton(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                menuMaxHeight: 230,
                isExpanded: true,
                style: TextStyle(
                    color: Color(Setting_Color.setting_gray), fontSize: 20),
                underline: Container(
                  height: 2,
                  color: Color(Setting_Color.setting_blue),
                ),
                icon: Icon(
                  Icons.timer,
                  size: 30,
                ),
                value: _selectedValue,
                items: <DropdownMenuItem>[
                  for (int i = 0; i < listmenu.length; i++) ...{
                    DropdownMenuItem(
                      value: listvalue[i],
                      child: Text(listmenu[i]),
                    ),
                  }
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
            ),
            Container(
              child: Text(
                'に設定',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 250),
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
                    await db_service.createglaph(widget.uid, _selectedValue);
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

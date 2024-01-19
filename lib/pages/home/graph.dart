import 'package:flutter/material.dart';
import 'package:word_magic/setting/setting_color.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      // AppBar
      appBar: AppBar(
        title: Text(
          '学習記録',
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
        child: Container(
          width: 100,
          height: 100,
          color: Colors.red,
        ),
      ),
    );
  }
}

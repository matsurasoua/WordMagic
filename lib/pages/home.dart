import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/card.dart';
import 'package:word_magic/pages/graph.dart';
import 'package:word_magic/pages/login.dart';
import 'package:word_magic/pages/main.dart';
import 'package:word_magic/pages/signup.dart';
import 'package:word_magic/setting/setting_color.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    CardPage(),
    GraphPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _widgetOptions[_selectedIndex],
        // BottomNavigationBar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                //x,y
                offset: Offset(0, 10),
                blurRadius: 5.0,
                spreadRadius: 8.0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BottomNavigationBar(
              elevation: 10.0,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: '',
                ),
                // Add other items as needed
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart_rounded),
                  label: '',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(setting_blue),
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

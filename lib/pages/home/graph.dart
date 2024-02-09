import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:word_magic/pages/auth/signup.dart';
import 'package:word_magic/pages/home/createglaph.dart';
import 'package:word_magic/pages/home/db_service.dart';
import 'package:word_magic/setting/setting_color.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final db_service = DB_Service();

  List<double> datas = [10, 3, 40, 20, 60, 30, 40];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final goaltime = snapshot.data?['goaltime'];
            print(goaltime);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: Color(setting_background),
                appBar: AppBar(
                  title: Text(
                    '学習時間',
                    style: TextStyle(
                        color: Color(Setting_Color.setting_blue),
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateGlaphPage(
                              uid: uid!,
                              nowtime: goaltime,
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.flag,
                        color: Color(Setting_Color.setting_red),
                        size: 30,
                      ),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '目標時間',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: goaltime,
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
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(0, 1),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            padding: EdgeInsets.only(
                                top: 60, left: 2, right: 20, bottom: 30),
                            width: 370,
                            height: 530,
                            child: BarChart(
                              swapAnimationCurve: Curves.bounceIn,
                              BarChartData(
                                backgroundColor:
                                    Color.fromARGB(255, 244, 244, 244),
                                extraLinesData:
                                    ExtraLinesData(horizontalLines: [
                                  HorizontalLine(
                                    y: double.parse(goaltime),
                                    color: Color(Setting_Color.setting_red),
                                    label: HorizontalLineLabel(
                                        show: true,
                                        labelResolver: (p0) => '目標値',
                                        style: TextStyle(
                                            color: Color(
                                                Setting_Color.setting_red),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        alignment: Alignment.topRight),
                                  )
                                ]),
                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                maxY: double.parse(goaltime) + 30,
                                gridData: FlGridData(horizontalInterval: 30),
                                groupsSpace: 5,
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    left: BorderSide(color: Colors.black),
                                    bottom: BorderSide(color: Colors.black),
                                  ),
                                ),
                                barGroups: [
                                  for (int i = 0; i < datas.length; i++) ...{
                                    BarChartGroupData(
                                      x: i + 3,
                                      barRods: [
                                        BarChartRodData(
                                          width: 15,
                                          fromY: 0,
                                          color:
                                              Color.fromARGB(255, 115, 226, 95),
                                          toY: datas[i],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0),
                                          ),
                                        )
                                      ],
                                    ),
                                  }
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '2月',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 37, left: 28),
                          alignment: Alignment.topLeft,
                          child: Text(
                            '(分)',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 485, right: 15),
                          alignment: Alignment.topRight,
                          child: Text(
                            '(日)',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

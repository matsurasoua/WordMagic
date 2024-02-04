import 'package:flutter/material.dart';
import 'package:word_magic/pages/auth/signup.dart';
import 'package:word_magic/setting/setting_color.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<double> datas = [10, 3, 40, 20, 60, 30, 40];
  @override
  Widget build(BuildContext context) {
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
                fontSize: 20),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        text: '70',
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
            Align(
              alignment: Alignment.bottomCenter,
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
                padding:
                    EdgeInsets.only(top: 60, left: 2, right: 20, bottom: 30),
                width: 370,
                height: 530,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    maxY: 100,
                    gridData: FlGridData(horizontalInterval: 10),
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
                          x: i,
                          barRods: [
                            BarChartRodData(
                              width: 15,
                              fromY: 0,
                              color: Colors.deepOrangeAccent,
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
          ],
        ),
      ),
    );
  }
}

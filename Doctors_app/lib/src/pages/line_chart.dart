import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_healthcare_app/src/theme/light_color.dart';

import '../service/event_channel.dart';

class LineChartPage extends StatefulWidget {
  LineChartPage({Key? key}) : super(key: key);

  final Color sinColor = LightColor.lightBlue;
  final Color cosColor = LightColor.orange;

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  final limitCount = 100;
  final sinPoints = <FlSpot>[];
  final cosPoints = <FlSpot>[];
  late StreamSubscription sub;

  // @override
  // void initState() {
  //   super.initState();
  //   timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
  //     while (sinPoints.length > limitCount) {
  //       sinPoints.removeAt(0);
  //       cosPoints.removeAt(0);
  //     }
  //     setState(() {
  //       sinPoints.add(FlSpot(xValue, math.sin(xValue)));
  //       cosPoints.add(FlSpot(xValue, math.cos(xValue)));
  //     });
  //     xValue += step;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    //  EventChannel stream reading
    sub = EventChannelTutorial().messageStream.listen((event) {
      print(event);
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
        cosPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(event, math.cos(event)));
        cosPoints.add(FlSpot(event, math.cos(event)));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColor.purple,
        title: Text('Hear Rate Monitor'),
      ),
      body: Container(
        child: cosPoints.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Average Heart Rate',
                          style: const TextStyle(
                            color: LightColor.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Text(
                            '60',
                            style: const TextStyle(
                              color: LightColor.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              'bpm',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Text(
                  //   'sin: ${sinPoints.last.y.toStringAsFixed(1)}',
                  //   style: TextStyle(
                  //     color: widget.sinColor,
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 49, child: Text('80')),
                            SizedBox(height: 49, child: Text('70')),
                            SizedBox(height: 49, child: Text('60')),
                            SizedBox(height: 49, child: Text('50')),
                            SizedBox(height: 49, child: Text('40')),
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          child: Center(
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width - 40,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: LineChart(
                                  LineChartData(
                                    minY: -1,
                                    maxY: 1,
                                    minX: sinPoints.first.x,
                                    maxX: sinPoints.last.x,
                                    lineTouchData:
                                        const LineTouchData(enabled: false),
                                    clipData: const FlClipData.all(),
                                    gridData: const FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                    ),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      sinLine(sinPoints),
                                      // cosLine(cosPoints),
                                    ],
                                    titlesData: FlTitlesData(
                                      // rightTitles: SideTitles(showTitles: false),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      bottomTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      leftTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // )
                  Divider(
                    height: 1,
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [widget.sinColor, widget.sinColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 2,
      isCurved: true,
    );
  }

  LineChartBarData cosLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [widget.cosColor.withOpacity(0), widget.cosColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AppDimens {
  static const double menuMaxNeededWidth = 304;
  static const double menuRowHeight = 74;
  static const double menuIconSize = 32;
  static const double menuDocumentationIconSize = 44;
  static const double menuTextSize = 20;

  static const double chartBoxMinWidth = 350;

  static const double defaultRadius = 8;
  static const double chartSamplesSpace = 32.0;
  static const double chartSamplesMinWidth = 350;
}

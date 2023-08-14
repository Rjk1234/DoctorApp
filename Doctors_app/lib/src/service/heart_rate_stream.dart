import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

class HeartRateStimulator {
  final limitCount = 100;
  late Timer timer;
  double xValue = 0;
  double step = 0.25;

  final bool _running = true;

  Stream<FlSpot> stimulateHeartRate() async* {
    while (_running) {
      await Future<void>.delayed(const Duration(milliseconds: 100));

      yield FlSpot(xValue, math.sin(xValue));
    }
  }
}

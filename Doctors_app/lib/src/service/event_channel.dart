import 'dart:async';
import 'package:flutter/services.dart';

class HeartRateEventChannel {
  static const MethodChannel _channel =
      const MethodChannel('heart_rate_event_channel');

  static const EventChannel _hearRateChannel =
      const EventChannel('heart_rate_event_channel');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // static Stream<double> get getRandomNumberStream {
  //   return _randomNumberChannel.receiveBroadcastStream().cast();
  // }

  Stream<double> get hearRateStream async* {
    await for (double message in _hearRateChannel
        .receiveBroadcastStream()
        .map((message) => message)) {
      yield message;
    }
  }
}

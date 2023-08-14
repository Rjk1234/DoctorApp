import 'dart:async';
import 'package:flutter/services.dart';

class EventChannelTutorial {
  static const MethodChannel _channel =
      const MethodChannel('heart_rate_event_channel');

  static const EventChannel _randomNumberChannel =
      const EventChannel('heart_rate_event_channel');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // static Stream<double> get getRandomNumberStream {
  //   return _randomNumberChannel.receiveBroadcastStream().cast();
  // }

  Stream<double> get messageStream async* {
    await for (double message in _randomNumberChannel
        .receiveBroadcastStream()
        .map((message) => message)) {
      yield message;
    }
  }
}

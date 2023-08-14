import Flutter
import UIKit

public class SwiftEventChannelTutorialPlugin: NSObject, FlutterPlugin {
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "heart_rate_event_channel", binaryMessenger: registrar.messenger())
    let instance = SwiftEventChannelTutorialPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    let randomNumberChannel = FlutterEventChannel(name: "heart_rate_event_channel", binaryMessenger: registrar.messenger())
    let randomNumberStreamHandler = RandomNumberStreamHandler()
    randomNumberChannel.setStreamHandler(randomNumberStreamHandler)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

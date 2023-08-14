import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    
    //variables for Event Channel
    var sink: FlutterEventSink?
    let streamIdentifire: String = "heart_rate_event_channel";
    var timer: Timer?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        //MARK: Event Channel
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        let eventChannel = FlutterEventChannel(name: streamIdentifire, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
        
        print("heart rate event config here")
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    //MARK: Flutter Event Channel Handle
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(sendHearRate), userInfo: nil, repeats: true)
        return nil
    }
    var xValue: Double = 0;
    var step: Double = 0.25;
    @objc func sendHearRate() {
        guard let sink = sink else { return }
        
        print("heart rate sink here")
        sink(xValue)
        xValue += step
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        timer?.invalidate()
        return nil
    }
    
}

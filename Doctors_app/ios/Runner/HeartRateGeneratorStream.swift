//
//  HeartRateGeneratorStream.swift
//  Runner
//
//  Created by Rajveer Kaur on 15/08/23.
//  Copyright © 2023 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter

class HeartRateGeneratorStream: NSObject {
    //variables for Event Channel
    var sink: FlutterEventSink?
    let streamIdentifire: String = "heart_rate_event_channel";
    var timer: Timer?
    var xValue: Double = 0;
    var step: Double = 0.25;
    
    /// Register event channel stream
    func registerStream(window: UIWindow?) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        let eventChannel = FlutterEventChannel(name: streamIdentifire, binaryMessenger: controller.binaryMessenger)
        eventChannel.setStreamHandler(self)
        
        print("heart rate event config here")
    }
    
}

extension HeartRateGeneratorStream: FlutterStreamHandler {
    //MARK: Flutter Event Channel Handle
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        timer = Timer.scheduledTimer(timeInterval: 0.09, target: self, selector: #selector(sendHearRate), userInfo: nil, repeats: true)
        return nil
    }
   
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

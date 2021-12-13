//
//  EventChannels.swift
//  Runner
//
//  Created by Shrey Gupta on 19/11/21.
//

import UIKit
import Flutter
import common

// swiftlint:disable superfluous_disable_command
// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
// swiftlint:disable vertical_whitespace


enum EventChannelName {
    static let repCount = "com.allycare.dev/repCount"
    static let feedback = "com.allycare.dev/feedback"
    static let elapsedTime = "com.allycare.dev/elapsedTime"
    static let holdTime = "com.allycare.dev/holdTime"
    static let showCalib = "com.allycare.dev/showCalib"
    static let isExFinished = "com.allycare.dev/isExFinished"
    static let actionStop = "com.allycare.dev/actionStop"
    static let currentIndex = "com.allycare.dev/currentIndex"
    static let liveLandmarks = "com.allycare.dev/liveLandmarks"
    static let showLoadingScreen = "com.allycare.dev/showLoadingScreen"
}

private enum EventChannelType: String {
    case repCount
    case feedback
    case holdTime
    case elapsedTime
    case showCalib
    case isExFinished
    case actionStop
    case currentIndex
    case liveLandmarks
    case showLoadingScreen
}

class EventChannel: NSObject, FlutterStreamHandler {
    static var shared = EventChannel()
    
    var repCountEventSink: FlutterEventSink?
    var feedbackEventSink: FlutterEventSink?
    var elapsedTimeEventSink: FlutterEventSink?
    var holdTimeEventSink: FlutterEventSink?
    var showCalibEventSink: FlutterEventSink?
    var isExFinishedEventSink: FlutterEventSink?
    var actionStopEventSink: FlutterEventSink?
    var currentIndexEventSink: FlutterEventSink?
    var liveLandmarksEventSink: FlutterEventSink?
    var showLoadingScreenEventSink: FlutterEventSink?
    
    func initAllChannels() {
        guard let binaryMessenger = appDele?.binaryMessenger else { return }
        
        let showLoadingScreenEventSink = FlutterEventChannel(name: EventChannelName.showLoadingScreen, binaryMessenger: binaryMessenger)
        showLoadingScreenEventSink.setStreamHandler(self)
        
        let repCountEventChannel = FlutterEventChannel(name: EventChannelName.repCount, binaryMessenger: binaryMessenger)
        repCountEventChannel.setStreamHandler(self)

        let feedbackEventChannel = FlutterEventChannel(name: EventChannelName.feedback, binaryMessenger: binaryMessenger)
        feedbackEventChannel.setStreamHandler(self)

        let elapsedTimeEventChannel = FlutterEventChannel(name: EventChannelName.elapsedTime, binaryMessenger: binaryMessenger)
        elapsedTimeEventChannel.setStreamHandler(self)

        let holdTimeEventChannel = FlutterEventChannel(name: EventChannelName.holdTime, binaryMessenger: binaryMessenger)
        holdTimeEventChannel.setStreamHandler(self)
        
        let showCalibEventSink = FlutterEventChannel(name: EventChannelName.showCalib, binaryMessenger: binaryMessenger)
        showCalibEventSink.setStreamHandler(self)
        
        let isExFinishedEventSink = FlutterEventChannel(name: EventChannelName.isExFinished, binaryMessenger: binaryMessenger)
        isExFinishedEventSink.setStreamHandler(self)
        
        let actionStopEventSink = FlutterEventChannel(name: EventChannelName.actionStop, binaryMessenger: binaryMessenger)
        actionStopEventSink.setStreamHandler(self)
        
        let currentIndexEventSink = FlutterEventChannel(name: EventChannelName.currentIndex, binaryMessenger: binaryMessenger)
        currentIndexEventSink.setStreamHandler(self)
        
        let liveLandmarksEventSink = FlutterEventChannel(name: EventChannelName.liveLandmarks, binaryMessenger: binaryMessenger)
        liveLandmarksEventSink.setStreamHandler(self)
    }
    
    // MARK: - Delegate FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        guard let arguments = arguments as? String else {
            return FlutterError(code: "Failed", message: "Unable to fetch arguments", details: nil)
        }
        
        guard let channelType = EventChannelType(rawValue: arguments) else {
            return FlutterError(code: "Failed", message: "Unable to find channel type", details: nil)
        }

        switch channelType {
        case .repCount:
            repCountEventSink = events
        case .feedback:
            feedbackEventSink = events
        case .elapsedTime:
            elapsedTimeEventSink = events
        case .holdTime:
            holdTimeEventSink = events
        case .showCalib:
            showCalibEventSink = events
        case .isExFinished:
            isExFinishedEventSink = events
        case .actionStop:
            actionStopEventSink = events
        case .currentIndex:
            currentIndexEventSink = events
        case .liveLandmarks:
            liveLandmarksEventSink = events
        case .showLoadingScreen:
            showLoadingScreenEventSink = events
        }
        
        return nil
    }

    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)

        guard let arguments = arguments as? String else {
            return FlutterError(code: "Failed", message: "Unable to fetch arguments.", details: nil)
        }
        
        guard let channelType = EventChannelType(rawValue: arguments) else {
            return FlutterError(code: "Failed", message: "Unable to find channel type", details: nil)
        }

        switch channelType {
        case .repCount:
            repCountEventSink = nil
        case .feedback:
            feedbackEventSink = nil
        case .elapsedTime:
            elapsedTimeEventSink = nil
        case .holdTime:
            holdTimeEventSink = nil
        case .showCalib:
            showCalibEventSink = nil
        case .isExFinished:
            isExFinishedEventSink = nil
        case .actionStop:
            actionStopEventSink = nil
        case .currentIndex:
            currentIndexEventSink = nil
        case .liveLandmarks:
            liveLandmarksEventSink = nil
        case .showLoadingScreen:
            showLoadingScreenEventSink = nil
        }
        
        return nil
    }
    
    // MARK: - RepCount Event Channel
    func updateRepCount(with count: KotlinInt) {
        guard let eventSink = repCountEventSink else { return }
        eventSink(count)
    }
    
    // MARK: - Feedback Event Channel
    func updateFeedback(with text: NSString) {
        guard let eventSink = feedbackEventSink else { return }
        eventSink(text)
    }
    
    // MARK: - ElapsedTime Event Channel
    func updateElapsedTime(with time: NSString) {
        guard let eventSink = elapsedTimeEventSink else { return }
        eventSink(time)
    }
    
    // MARK: - HoldTime Event Sink
    func updateHoldTime(with time: KotlinInt) {
        guard let eventSink = holdTimeEventSink else { return }
        eventSink(time)
    }
    
    // MARK: - ShowCalib Event Sink
    func updateShowCalib(with showCalib: KotlinBoolean) {
        guard let eventSink = showCalibEventSink else { return }
        eventSink(Bool(truncating: showCalib))
    }
    
    // MARK: - ExFinished Event Sink
    func updateIsExFinished(with isExFinished: KotlinBoolean) {
        guard let eventSink = isExFinishedEventSink else { return }
        eventSink(Bool(truncating: isExFinished))
    }
    
    // MARK: - ActionStop Event Sink
    func updateActionStop(with actionStop: KotlinBoolean) {
        guard let eventSink = actionStopEventSink else { return }
        eventSink(Bool(truncating: actionStop))
    }
    
    // MARK: - CurrentIndex Event Sink
    func updateCurrentIndex(with index: Int32) {
        guard let eventSink = currentIndexEventSink else { return }
        eventSink(index)
    }
    
    // MARK: - LiveLandmarks Event Sink
    func liveLandmarks(landmarks: [NativeLandmark]) {
        guard let eventSink = liveLandmarksEventSink else { return }
        
        // parsing
        var allLandmarksData = [String]()
        
        landmarks.forEach { landmark in
            allLandmarksData.append(landmark.toJson())
        }
        
        eventSink(allLandmarksData)
    }
    
    // MARK: - ShouldShowLoading Event Sink
    func shouldShowLoading(shouldShow: Bool) {
        guard let eventSink = showLoadingScreenEventSink else { return }
        eventSink(shouldShow)
    }
}

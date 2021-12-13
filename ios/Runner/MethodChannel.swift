//
//  MethodChannel.swift
//  Runner
//
//  Created by Shrey Gupta on 19/11/21.
//

import UIKit
import Flutter
import MapKit
import common

// swiftlint:disable superfluous_disable_command
// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
// swiftlint:disable vertical_whitespace

enum MethodChannelType: String {
    case setAllExercises
    case startNextExercise
    case skipCurrentExercise
    case finishAllExercises
    case removeCalibration
    case disposeSession
}

protocol MethodChannelDelegate: AnyObject {
    func didUpdateAllExercises()
    func startNextExercise()
    func skipCurrentExercise()
    func finishAllExercises()
    func removeCalibration()
    func disposeSession() -> Bool
}

class MethodChannel: NSObject {
    static let channelName = "com.allycare.dev"
    static var shared = MethodChannel()
    
    var allExercises = [Exercise]()
    
    weak var delegate: MethodChannelDelegate?
    
    func initAllChannels() {
        guard let binaryMessenger = appDele?.binaryMessenger else { return }
        
        let totalRepsMethodChannel = FlutterMethodChannel(name: MethodChannel.channelName, binaryMessenger: binaryMessenger)
        totalRepsMethodChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // Note: this method is invoked on the UI thread.
            guard let methodType = MethodChannelType(rawValue: call.method) else { return }
            
            switch methodType {
            case .setAllExercises:
                guard let args = call.arguments as? [String: Any] else { return }
                guard let exerciseData = args["data"] as? [[String: Any]] else { return }
                
                var allExercises = [Exercise]()
                
                exerciseData.forEach { data in
                    let name = data["name"] as? String ?? ""
                    let holdTime = data["holdTime"] as? Int32 ?? Int32(0)
                    let repCount = data["repCount"] as? Int32 ?? Int32(0)
                    let video = data["video"] as? String ?? ""
                    let practice = data["practice"] as? String ?? ""
                    let repition = data["repititions"] as? Int32 ?? Int32(0)
                    let id = data["id"] as? Int32 ?? Int32(0)
                    let exercise = Exercise(name: name, hold_time: holdTime, rep_count: repCount, video: video, practice: practice, id: id, repetition: repition)
                    allExercises.append(exercise)
                }
                
                self.allExercises = allExercises

                self.delegate?.didUpdateAllExercises()
            case .startNextExercise:
                self.delegate?.startNextExercise()
            case .skipCurrentExercise:
                self.delegate?.skipCurrentExercise()
            case .finishAllExercises:
                self.delegate?.finishAllExercises()
            case .removeCalibration:
                self.delegate?.removeCalibration()
            case .disposeSession:
                result(self.delegate?.disposeSession())
                return
            }
            
            result(true)
        })
    }
}

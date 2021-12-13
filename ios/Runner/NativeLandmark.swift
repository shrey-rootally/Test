//
//  NativeLandmark.swift
//  Runner
//
//  Created by Shrey Gupta on 02/12/21.
//

import UIKit
import common

// swiftlint:disable superfluous_disable_command
// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
// swiftlint:disable vertical_whitespace
// swiftlint:disable identifier_name

class NativeLandmark: Codable {
    let index: Int
    let x: Float
    let y: Float
    let z: Float
    let visibility: Float
    let presence: Float
    
    init(mpLandmark: Landmark) {
        self.index = Int(mpLandmark.index)
        self.x = mpLandmark.x
        self.y = mpLandmark.y
        self.z = mpLandmark.z
        self.visibility = mpLandmark.visibility
        self.presence = mpLandmark.presence
    }
    
    func toJson() -> String {
        var dict = [String: Any]()
        dict["index"] = self.index
        dict["x"] = self.x
        dict["y"] = self.y
        dict["z"] = self.z
        dict["visibility"] = self.visibility
        dict["presence"] = self.presence
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]) else { return "nUll"}
        return String(data: jsonData, encoding: String.Encoding.ascii) ?? "null"
    }
}

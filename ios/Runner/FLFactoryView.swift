//
//  FLFactoryView.swift
//  Runner
//
//  Created by Shrey Gupta on 01/11/21.
//

import UIKit
import Flutter

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return TrackerView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
    
    deinit {
        print("DEBUG:- FLNativeViewFactory DEINIT")
    }
}


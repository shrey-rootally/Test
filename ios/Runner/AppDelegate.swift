import UIKit
import Flutter
import Firebase

// swiftlint:disable trailing_whitespace
// swiftlint:disable vertical_whitespace
// swiftlint:disable line_length

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var binaryMessenger: FlutterBinaryMessenger?
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        
        guard let controller: FlutterViewController = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        self.binaryMessenger = controller.binaryMessenger
        
        // MARK: - Method Channels Init
        MethodChannel.shared.initAllChannels()
        
        // MARK: - Event Channels Init
        EventChannel.shared.initAllChannels()
        
        weak var registrar = self.registrar(forPlugin: "plugin-name")
        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
        self.registrar(forPlugin: "<plugin-name>")!.register(factory, withId: "<platform-view-type>")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

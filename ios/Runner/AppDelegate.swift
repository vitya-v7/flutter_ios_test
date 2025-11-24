
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    
    private var helloChannel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docsURL.appendingPathComponent("hello.txt")
        try? FileManager.default.removeItem(at: fileURL) // просто удаляем старый файл
        
        let messenger = engineBridge.applicationRegistrar.messenger()
        
        let channel = FlutterMethodChannel(
            name: "sample.viktor/hello",
            binaryMessenger: messenger
        )
        self.helloChannel = channel
        
        channel.setMethodCallHandler { [weak self] call, result in
            guard call.method == "writeHello" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.handleWriteHello(call: call, result: result)
        }
    }
    
    // Дергаем C++
    private func handleWriteHello(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let n = args["n"] as? Int else {
            result(FlutterError(code: "BAD_ARGS", message: "n is required", details: nil))
            return
        }
        
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docsURL.appendingPathComponent("hello.txt")
        
        let append = true
        
        let ok = write_hello_line(fileURL.path, Int32(n), append)
        guard ok else {
            result(FlutterError(code: "WRITE_FAILED", message: "C++ write failed", details: nil))
            return
        }
        
        let content = (try? String(contentsOf: fileURL, encoding: .utf8)) ?? ""
        result(content)
    }
}

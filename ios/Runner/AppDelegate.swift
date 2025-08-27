import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Set window background color to match splash screen background (primary color)
    // This prevents any blank screen from appearing
    if let window = self.window {
      // Use primary color (#7171FF) to match splash screen
      window.backgroundColor = UIColor(red: 113/255, green: 113/255, blue: 255/255, alpha: 1.0)
      
      // Ensure the launch screen persists until Flutter is ready
      // This prevents any gap between native launch and Flutter initialization
      if let controller = window.rootViewController as? FlutterViewController {
        controller.isViewOpaque = false
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    
    // Ensure splash screen colors remain consistent
    if let window = self.window {
      window.backgroundColor = UIColor(red: 113/255, green: 113/255, blue: 255/255, alpha: 1.0)
    }
  }
}

import UIKit
import Flutter

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

    // Setup region detection method channel
    setupRegionChannel()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Setup method channel for region detection
  private func setupRegionChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let regionChannel = FlutterMethodChannel(
      name: "com.getvenyu.app/region",
      binaryMessenger: controller.binaryMessenger
    )

    regionChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "getRegion" {
        // Get region code from iOS system settings
        let regionCode = Locale.current.regionCode ?? "NL"
        result(regionCode)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)

    // Ensure splash screen colors remain consistent
    if let window = self.window {
      window.backgroundColor = UIColor(red: 113/255, green: 113/255, blue: 255/255, alpha: 1.0)
    }
  }

  // CRITICAL: Handle Universal Links to prevent Safari from opening
  // This method tells iOS that the app successfully handled the Universal Link
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    // First, let the super class (app_links plugin) handle the link
    let handled = super.application(application, continue: userActivity, restorationHandler: restorationHandler)

    // If app_links handled it, return true
    if handled {
      return true
    }

    // Otherwise, check if it's a Universal Link and handle it ourselves
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      // The link is received and will be handled by Flutter's DeepLinkService
      // CRITICAL: Return true to tell iOS we handled it and prevent Safari from opening
      NSLog("Universal Link received in AppDelegate: \(url.absoluteString)")
      return true
    }

    return false
  }
}

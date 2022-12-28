import UIKit
import Flutter
import GoogleMaps // 여기 밑에 3개도 넣어야하고
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // 이부분이 들어가야 한다.
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  Messaging.messaging().apnsToken = deviceToken
    print("Token: \(deviceToken)")
    super.application(application,
    didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
    )
  }
  )
}

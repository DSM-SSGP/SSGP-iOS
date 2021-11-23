import UIKit
import RxSwift
import KeychainSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let disposeBag = DisposeBag()
    private let keychain = KeychainSwift()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        HTTPClient.shared.networking(
            api: .tokenRefresh,
            model: TokenModel.self
        ).subscribe(onSuccess: { token in

            self.keychain.set(token.access_token, forKey: "ACCESS-TOKEN")
            self.keychain.set(token.refresh_token, forKey: "REFRESH-TOKEN")

            let rootViewController = TabBarController()
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = R.color.background()

        }, onFailure: { _ in

            let rootViewController = LoginViewController()
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
            self.window?.backgroundColor = R.color.background()

        }).disposed(by: disposeBag)

        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()

        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("[Log] deviceToken :", deviceTokenString)
        Messaging.messaging().apnsToken = deviceToken
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }

}

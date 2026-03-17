import SwiftUI
import SwiftData
import StoreKit
import UIKit
import FirebaseCore
import FirebaseMessaging

@main
struct SpeedRodeoSXApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserStatsSX.self,
            CompletedTaskSX.self,
            FavoriteItemSX.self,
            HorseBreedSX.self,
            TrainingSessionSX.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var iapManager = IAPManagerVE.shared
    @State private var themeManager = ThemeManagerSX.shared
    @AppStorage("isFirstLaunchUE") private var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            RootViewMC()
                .environment(iapManager)
                .environment(themeManager)
                .preferredColorScheme(.dark)
                .id(themeManager.currentTheme)
                .environmentObject(LoaderViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}

@MainActor
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        FirebaseApp.configure()
        SKPaymentQueue.default().add(IAPManagerVE.shared)
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        print("✅ Firebase configured")
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(IAPManagerVE.shared)
    }
    
    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                if orientationLock == .landscape {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orient")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orient")
                }
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for APNs: \(error)")
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apns = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("📬 APNs token: \(apns)")

        UserDefaults.standard.set(true, forKey: "apnsReady")
        UserDefaults.standard.set(apns, forKey: "apnsTokenHex")
        NotificationCenter.default.post(name: .apnsTokenDidUpdate, object: nil, userInfo: ["apns": apns])

        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken, !token.isEmpty else {
            print("⚠️ didReceiveRegistrationToken empty")
            return
        }
        UserDefaults.standard.set(token, forKey: "fcmToken")
        print("🔥 FCM token (delegate): \(token)")
        NotificationCenter.default.post(name: .fcmTokenDidUpdate, object: nil, userInfo: ["token": token])
    }
}

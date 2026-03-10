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
            MainViewSX()
                .environment(iapManager)
                .environment(themeManager)
                .preferredColorScheme(.dark)
                .id(themeManager.currentTheme)
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

        SKPaymentQueue.default().add(IAPManagerVE.shared)
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(IAPManagerVE.shared)
    }
}

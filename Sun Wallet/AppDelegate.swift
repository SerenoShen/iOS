import UIKit
import LocalAuthentication
import Analytics
import segment_appsflyer_ios
import Lokalise

class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {

    private var window: UIWindow? {
        return applicationController.window
    }
    let applicationController = ApplicationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /*var configuration = SEGAnalyticsConfiguration(writeKey: "XH2l6b3nKniFJ3q5rtUY9skD2hvYaUDv")
        configuration.trackApplicationLifecycleEvents = true
        configuration.recordScreenViews = true
        SEGAnalytics.init(configuration: configuration)*/

        AppsFlyerTracker.shared().appsFlyerDevKey = "BzWcFLsYyE87vCB6AqKbQG";
        AppsFlyerTracker.shared().appleAppID = "1437716766"
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = true

        Lokalise.shared.setAPIToken("977567f3f31bcab6a183973e61fb0cf17e0cf49f", projectID: "633386625bafa36bcd7a33.90054023")
        Lokalise.shared.swizzleMainBundle()

        redirectStdOut()
        UIView.swizzleSetFrame()
        applicationController.launch(application: application, options: launchOptions)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerTracker.shared().trackAppLaunch()
        UIApplication.shared.applicationIconBadgeNumber = 0
        applicationController.didBecomeActive()
        Lokalise.shared.checkForUpdates { (updated: Bool, error: Error?) in

        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        applicationController.willEnterForeground()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        applicationController.didEnterBackground()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        applicationController.willResignActive()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        applicationController.performFetch(completionHandler)
    }

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool {
        return false // disable extensions such as custom keyboards for security purposes
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        applicationController.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        applicationController.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: restorationHandler)
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, sourceApplication: sourceApplication, withAnnotation: annotation)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return applicationController.open(url: url)
    }

    //stdout is redirected to C.logFilePath for testflight builds
    private func redirectStdOut() {
        guard E.isTestFlight else { return }
        C.logFilePath.withUnsafeFileSystemRepresentation {
            _ = freopen($0, "w+", stdout)
        }
    }
}


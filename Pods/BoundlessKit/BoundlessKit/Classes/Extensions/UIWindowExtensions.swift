//
//  UIWindowExtensions.swift
//  BoundlessKit
//
//  Created by Akash Desai on 12/1/17.
//

import Foundation

internal extension UIWindow {
    static func presentTopLevelAlert(alertController:UIAlertController, completion:(() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertController, animated: true, completion: completion)
        }
    }
}

internal extension UIWindow {
    class var topWindow: UIWindow? {
        get {
            guard let UIApplicationShared = Application.shared else { return nil }
            if let window = UIApplicationShared.keyWindow {
                return window
            }
            for window in UIApplicationShared.windows.reversed() {
                if window.windowLevel == UIWindowLevelNormal && !window.isHidden && window.frame != CGRect.zero { return window }
            }
            return nil
        }
    }
}

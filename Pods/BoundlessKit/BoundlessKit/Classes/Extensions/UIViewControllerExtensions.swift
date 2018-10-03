//
//  UIViewControllerExtensions.swift
//  BoundlessKit
//
//  Created by Akash Desai on 4/9/18.
//

import Foundation

internal class Application {
    static var shared: UIApplication? {
        let sharedSelector = NSSelectorFromString("sharedApplication")
        guard UIApplication.responds(to: sharedSelector) else {
                return nil
        }
        return UIApplication.perform(sharedSelector)?.takeUnretainedValue() as? UIApplication
    }
}

internal extension UIViewController {
    static func getViewControllers(ofType aClass: AnyClass) -> [UIViewController] {
        return Application.shared?.windows.reversed().compactMap({$0.rootViewController?.getChildViewControllers(ofType: aClass)}).flatMap({$0}) ?? []
    }
    
    func getChildViewControllers(ofType aClass: AnyClass) -> [UIViewController] {
        var vcs = [UIViewController]()
        
        if aClass == type(of: self) {
            vcs.append(self)
        }
        
        if let tabController = self as? UITabBarController,
            let tabVCs = tabController.viewControllers {
            for vc in tabVCs.reversed() {
                vcs += vc.getChildViewControllers(ofType: aClass)
            }
        } else if let navController = self as? UINavigationController {
            for vc in navController.viewControllers.reversed() {
                vcs += vc.getChildViewControllers(ofType: aClass)
            }
        } else {
            if let vc = self.presentedViewController {
                vcs += vc.getChildViewControllers(ofType: aClass)
            }
            for vc in childViewControllers.reversed() {
                vcs += vc.getChildViewControllers(ofType: aClass)
            }
        }
        
        return vcs
    }
}

import UIKit

class StartNavigationDelegate : NSObject, UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if viewController is RecoverWalletIntroViewController {
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.customBold(size: 17.0)
            ]
            navigationController.setClearNavbar()
            navigationController.navigationBar.barTintColor = .clear
        }

        if viewController is EnterPhraseViewController {
            navigationController.navigationBar.tintColor = UIColor(named: "navigationTint")
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.customBold(size: 17.0)
            ]
            navigationController.setClearNavbar()
        }

        if viewController is UpdatePinViewController {
            navigationController.navigationBar.tintColor = UIColor(named: "navigationTint")
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.customBold(size: 17.0)
            ]
            navigationController.setClearNavbar()
        }

        if viewController is UpdatePinViewController {
            if let gr = navigationController.interactivePopGestureRecognizer {
                navigationController.view.removeGestureRecognizer(gr)
            }
        }

        if viewController is StartWipeWalletViewController {
            navigationController.setClearNavbar()
            navigationController.setWhiteStyle()
        }
    }
}

import UIKit

extension UINavigationController {

    func setDefaultStyle() {
        setClearNavbar()
        navigationBar.tintColor = UIColor(named: "darkText")
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.header
        ]
    }

    func setWhiteStyle() {
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.header
        ]
    }
    
    func setDarkStyle() {
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .blackOpaque
        navigationBar.barTintColor = UIColor(named: "navigationBackground")
        navigationBar.tintColor = UIColor(named: "navigationTint")
        navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.header
        ]
    }

    func setClearNavbar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}

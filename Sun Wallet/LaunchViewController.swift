import UIKit
import Pastel
import TinyConstraints

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .topLeft
        pastelView.endPastelPoint = .bottomRight
        pastelView.animationDuration = 1.5
        pastelView.setColors([UIColor(red: 255.0/255.0, green: 202.0/255.0, blue: 63.0/255.0, alpha: 1.0),
                              UIColor(red: 247.0/255.0, green: 181.0/255.0, blue: 51.0/255.0, alpha: 1.0),
                              UIColor(red: 255.0/255.0, green: 187.0/255.0, blue: 69.0/255.0, alpha: 1.0),
                              UIColor(red: 255.0/255.0, green: 172.0/255.0, blue: 38.0/255.0, alpha: 1.0)])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)

        let logoView = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(logoView)
        logoView.width(311)
        logoView.height(94)
        logoView.center(in: view)

    }


}

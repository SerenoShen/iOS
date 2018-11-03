import UIKit
import Pastel
import TinyConstraints

class StartViewController : UIViewController {

    //MARK: - Public
    init(didTapCreate: @escaping () -> Void, didTapRecover: @escaping () -> Void) {
        self.didTapRecover = didTapRecover
        self.didTapCreate = didTapCreate
        super.init(nibName: nil, bundle: nil)
    }

    //MARK: - Private
    private let message = CutoutLabel(font: .customMedium(size: 18.0), color: .white)
    private let create = SUNButton(title: S.StartViewController.createButton, type: .primary)
    private let recover = SUNButton(title: S.StartViewController.recoverButton, type: .secondaryTransparent)
    private let didTapRecover: () -> Void
    private let didTapCreate: () -> Void
    let logoView = UIImageView(image: UIImage(named: "logo"))

    override func viewDidLoad() {
        setData()
        addSubviews()
        addConstraints()
        addButtonActions()
    }

    private func setData() {
        message.text = S.StartViewController.message
        message.lineBreakMode = .byWordWrapping
        message.numberOfLines = 0
        message.textAlignment = .center
    }

    private func addSubviews() {
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


        view.addSubview(logoView)
        logoView.width(311)
        logoView.height(94)
        logoView.center(in: view)

        view.addSubview(message)
        //message.width(logoView.wid)
        view.addSubview(create)
        view.addSubview(recover)

    }

    private func addConstraints() {
        recover.constrain([
            recover.constraint(.leading, toView: view, constant: C.padding[2]),
            recover.constraint(.bottom, toView: view, constant: -C.padding[6]),
            recover.constraint(.trailing, toView: view, constant: -C.padding[2]),
            recover.constraint(.height, constant: C.Sizes.buttonHeight) ])
        create.constrain([
            create.constraint(toTop: recover, constant: -C.padding[2]),
            create.constraint(.centerX, toView: recover, constant: nil),
            create.constraint(.width, toView: recover, constant: nil),
            create.constraint(.height, constant: C.Sizes.buttonHeight) ])
    }

    private func addButtonActions() {
        recover.tap = didTapRecover
        create.tap = didTapCreate
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

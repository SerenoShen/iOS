import UIKit

class WhiteNumberPad : GenericPinPadCell {

    override var style: PinPadStyle {
        get { return .white }
        set {}
    }

    override func setAppearance() {
        if isHighlighted {
            backgroundColor = UIColor(named: "secondaryShadow")
            label.textColor = UIColor(named: "darkText")
        } else {
            if text == "" || text == PinPadViewController.SpecialKeys.delete.rawValue {
                backgroundColor = UIColor(named: "whiteTint")
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = UIColor(named: "grayTextTint")
            } else {
                backgroundColor = UIColor(named: "whiteTint")
                label.textColor = UIColor(named: "grayTextTint")
            }
        }
    }

    override func addConstraints() {
        label.constrain(toSuperviewEdges: nil)
        imageView.constrain(toSuperviewEdges: nil)
    }
}

import UIKit

class WhiteDecimalPad : GenericPinPadCell {

    override var style: PinPadStyle {
        get { return .white }
        set {}
    }

    override func setAppearance() {
        if isHighlighted {
            label.backgroundColor = UIColor(named: "secondaryShadow")
            label.textColor = UIColor(named: "darkText")
        } else {
            label.backgroundColor = .white
            label.textColor = UIColor(named: "grayTextTint")
        }
    }

    override func addConstraints() {
        label.constrain(toSuperviewEdges: nil)
        imageView.constrain(toSuperviewEdges: nil)
    }
}

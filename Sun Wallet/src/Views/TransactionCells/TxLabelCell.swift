import UIKit

class TxLabelCell: TxDetailRowCell {
    
    // MARK: - Accessors
    
    public var value: String {
        get {
            return valueLabel.text ?? ""
        }
        set {
            valueLabel.text = newValue
        }
    }

    // MARK: - Views
    
    fileprivate let valueLabel = UILabel(font: UIFont.customBody(size: 14.0))
    
    // MARK: - Init
    
    override func addSubviews() {
        super.addSubviews()
        container.addSubview(valueLabel)
    }
    
    override func addConstraints() {
        super.addConstraints()
        
        valueLabel.constrain([
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: C.padding[1]),
            valueLabel.constraint(.trailing, toView: container),
            valueLabel.constraint(.top, toView: container),
            valueLabel.constraint(.bottom, toView: container)
            ])
    }
    
    override func setupStyle() {
        super.setupStyle()
        valueLabel.textColor = UIColor(named: "darkGray")
        valueLabel.textAlignment = .right
    }
}

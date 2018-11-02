import UIKit
import CoreMotion

class MotionGradientView : UIView {

    private let motionLayer = MotionGradientLayer()

    init() {
        super.init(frame: .zero)
        motionLayer.frame = .zero
        layer.insertSublayer(motionLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        motionLayer.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MotionGradientLayer : CAGradientLayer {

    private var gradientColors = [UIColor(named: "newGradientStart")!.cgColor, UIColor(named: "newGradientEnd")!.cgColor]
    private var motion: CMMotionManager?

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        startPoint = CGPoint(x: 1.0, y: 0.0) //top right
        endPoint = CGPoint(x: 0.0, y: 1.0) //bottom left
        drawsAsynchronously = true
        colors = gradientColors
        startMotion()
    }

    private func startMotion() {
        colors = gradientColors
        drawsAsynchronously = true
        speed = 0
        add(CABasicAnimation.motionAnimation(colors: gradientColors.reversed()), forKey: "MotionShift")

        let motion = CMMotionManager()
        if motion.isAccelerometerAvailable {
            motion.startAccelerometerUpdates(to: OperationQueue.main, withHandler: { [weak self] (data, error) in
                guard let data = data else { return }
                var x = data.acceleration.x + 0.5
                x = max(min(x, 1), 0)
                self?.timeOffset = x
            })
        }
        self.motion = motion
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension CABasicAnimation {
    class func motionAnimation(colors: [CGColor]) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.toValue = colors
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.duration = 1.0
        return animation
    }
}


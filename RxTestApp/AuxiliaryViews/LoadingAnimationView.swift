//
//  LoadingAnimationView.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 7.05.2021.
//

import UIKit

class LoadingAnimationView: UIView {
    
    private let outerLayer = CAShapeLayer()
    private let middleLayer = CAShapeLayer()
    private let innerLayer = CAShapeLayer()
    private let mostInnerLayer = CAShapeLayer()
    let pi = CGFloat.pi
    
    private var outerPath = UIBezierPath()
    private var middlePath = UIBezierPath()
    private var innerPath = UIBezierPath()
    private var mostInnerPath = UIBezierPath()
    
    static let shared = LoadingAnimationView()
    
    private init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    func show() {
        addSelf()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.addAnimations()
        }
    }
    
    func hide() {
        outerLayer.removeAllAnimations()
        outerLayer.removeFromSuperlayer()
        
        middleLayer.removeAllAnimations()
        middleLayer.removeFromSuperlayer()
        
        innerLayer.removeAllAnimations()
        innerLayer.removeFromSuperlayer()
        
        mostInnerLayer.removeAllAnimations()
        mostInnerLayer.removeFromSuperlayer()

        self.removeFromSuperview()
    }
    
    private func addSelf() {
        guard let currentWindow = UIApplication.shared.windows.first else {
            return
        }
        
        currentWindow.addSubview(self)
        self.frame = currentWindow.frame
        
        let c = CGPoint(x: currentWindow.bounds.midX, y: currentWindow.bounds.midY)
        
        outerPath = UIBezierPath(arcCenter: c,
                                        radius: 60,
                                        startAngle: -pi/2,
                                        endAngle: 3*pi/2,
                                        clockwise: true)
        
        middlePath = UIBezierPath(arcCenter: c,
                                        radius: 45,
                                        startAngle: -pi/2,
                                        endAngle: 3*pi/2,
                                        clockwise: true)
        
        innerPath = UIBezierPath(arcCenter: c,
                                        radius: 30,
                                        startAngle: -pi/2,
                                        endAngle: 3*pi/2,
                                        clockwise: true)
        
        mostInnerPath = UIBezierPath(arcCenter: c,
                                        radius: 15,
                                        startAngle: -pi/2,
                                        endAngle: 3*pi/2,
                                        clockwise: true)
        
    }
    
    private func addAnimations() {
        addShapeLayer(baseLayer: outerLayer, path: outerPath, end: 0, color: .blue)
        addShapeLayer(baseLayer: middleLayer, path: middlePath, end: 1, color: .orange)
        addShapeLayer(baseLayer: innerLayer, path: innerPath, end: 0, color: .blue)
        addShapeLayer(baseLayer: mostInnerLayer, path: mostInnerPath, end: 1, color: .orange)
        
        addAnimation(to: outerLayer, end: 1)
        addAnimation(to: middleLayer, end: 0)
        addAnimation(to: innerLayer, end: 1)
        addAnimation(to: mostInnerLayer, end: 0)
    }
    
    private func addShapeLayer(baseLayer: CAShapeLayer, path: UIBezierPath, end: CGFloat, color: UIColor) {
        layer.addSublayer(baseLayer)
        baseLayer.path = path.cgPath
        baseLayer.strokeColor = color.cgColor
        baseLayer.lineWidth = 5
        baseLayer.lineCap = .round
        baseLayer.fillColor = UIColor.clear.cgColor
        baseLayer.strokeEnd = end
        baseLayer.strokeStart = end - 0.1
        
    }
    
    private func addAnimation(to shapeLayer: CAShapeLayer, end: CGFloat) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.toValue = end
        strokeAnimation.duration = 1.5
        strokeAnimation.fillMode = .forwards
        strokeAnimation.autoreverses = true
        strokeAnimation.repeatCount = .infinity
        
        let strokeAnimation2 = CABasicAnimation(keyPath: "strokeStart")
        strokeAnimation2.toValue = end - 0.1
        strokeAnimation2.duration = 1.5
        strokeAnimation2.fillMode = .forwards
        strokeAnimation2.autoreverses = true
        strokeAnimation2.repeatCount = .infinity
        
        shapeLayer.add(strokeAnimation, forKey: "")
        shapeLayer.add(strokeAnimation2, forKey: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

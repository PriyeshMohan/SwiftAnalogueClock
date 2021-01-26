//
//  UIView+Extension.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        layer.position = position
        layer.anchorPoint = point
    }
    
    func rotateTo(degree: CGFloat = .pi * 2.0, duration: CFTimeInterval, repeatAnimation: Bool = true) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = degree
        rotateAnimation.duration = duration
        if repeatAnimation {
            rotateAnimation.repeatCount = .greatestFiniteMagnitude
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

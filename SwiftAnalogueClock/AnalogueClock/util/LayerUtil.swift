//
//  LayerUtil.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

struct LayerUtil {
    
    static func arcLayer(arcCenter: CGPoint,radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, strokeColor: UIColor,lineWidth: CGFloat,fillColor: UIColor, clockWise: Bool) -> CAShapeLayer {
        let arcPath =  UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        return CAShapeLayer().makeLayer(path: arcPath, lineWidth: lineWidth, fillColor: fillColor, strokeColor: strokeColor)
    }
    
    static func lineLayer(startPoint: CGPoint, endPoint: CGPoint, lineWidth: CGFloat, fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        return CAShapeLayer().makeLayer(path: linePath, lineWidth: lineWidth, fillColor: fillColor, strokeColor: strokeColor)
    }
    
    static func rotateLayerAnimation(startAngle: CGFloat, endAngle: CGFloat, duration: CFTimeInterval, repeatAnimation: Bool = false) -> CABasicAnimation {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = startAngle
        rotateAnimation.toValue = endAngle
        rotateAnimation.duration = duration
        rotateAnimation.autoreverses = false
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.fillMode = .forwards
        if repeatAnimation {
            rotateAnimation.repeatCount = .greatestFiniteMagnitude
        }
        return rotateAnimation
    }
}

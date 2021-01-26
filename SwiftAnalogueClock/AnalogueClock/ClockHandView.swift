//
//  ClockHandView.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

class ClockHandView: UIView {
    
    var handLayer: CALayer?
    var centralCircleLayer: CALayer?
    var strokeColor: UIColor? {
        didSet {
            addHandLayer()
        }
    }
    var lineWidth: CGFloat? {
        didSet {
            addHandLayer()
        }
    }
    var fillColor: UIColor? {
        didSet {
            addHandLayer()
        }
    }
    var customPath: UIBezierPath? {
        didSet {
            addHandLayer()
        }
    }
    override var bounds: CGRect {
        didSet {
            addHandLayer()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addHandLayer()
    }
    
    override func draw(_ rect: CGRect) {
        addHandLayer()
    }
    
    func addHandLayer() {
        if let clockHandLayer = handLayer, let centralLayer = centralCircleLayer {
            clockHandLayer.removeFromSuperlayer()
            centralLayer.removeFromSuperlayer()
        }
        let handViewLayer = CAShapeLayer().makeLayer(path: customPath ?? defaultHandPath(), lineWidth: lineWidth ?? bounds.width/2, fillColor: fillColor ?? .red, strokeColor: strokeColor ?? .black)
        let centralLayer = LayerUtil.arcLayer(arcCenter: CGPoint(x: bounds.width/2, y: bounds.height), radius: bounds.width, startAngle: 0, endAngle: 2 * CGFloat.pi, strokeColor: strokeColor ?? .black, lineWidth: lineWidth ?? 1, fillColor: fillColor ?? .red, clockWise: true)
        self.layer.addSublayer(handViewLayer)
        self.layer.addSublayer(centralLayer)
        centralCircleLayer = centralLayer
        handLayer = handViewLayer
    }
    
    func defaultHandPath() -> UIBezierPath {
        let handLayerPath = UIBezierPath()
        handLayerPath.move(to: CGPoint(x: bounds.width/2, y: 0))
        handLayerPath.addLine(to: CGPoint(x: 0, y: bounds.height/10))
        handLayerPath.addLine(to: CGPoint(x: 0, y: bounds.height - bounds.width/2))
        handLayerPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height - bounds.width/2))
        handLayerPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height/10))
        handLayerPath.addLine(to: CGPoint(x: bounds.width/2, y: 0))
        handLayerPath.close()
        return handLayerPath
    }
    
    func addLayerAnimation(startAngle: CGFloat, endAngle: CGFloat, duration: CFTimeInterval, repeatAnimation: Bool = false) {
        self.layer.add(LayerUtil.rotateLayerAnimation(startAngle: startAngle, endAngle: endAngle, duration: duration, repeatAnimation: repeatAnimation), forKey: nil)
    }
    
    func addLayerAnimation(animation: CAAnimation) {
        self.layer.add(animation, forKey: nil)
    }
    
    func pause() {
        self.layer.pauseAnimation()
    }
    
    func resume() {
        self.layer.resumeAnimation()
    }
}

//
//  SecondHandView.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

final class SecondHandView: ClockHandView {
    
    override func addHandLayer() {
        if let clockHandLayer = handLayer, let centralLayer = centralCircleLayer {
            clockHandLayer.removeFromSuperlayer()
            centralLayer.removeFromSuperlayer()
        }
        let handViewLayer = CAShapeLayer().makeLayer(path: customPath ?? defaultHandPath(), lineWidth: 1, fillColor: fillColor ?? .black, strokeColor: strokeColor ?? .black)
        let centralLayer = LayerUtil.arcLayer(arcCenter: CGPoint(x: bounds.width/2, y: 3*bounds.height/4), radius: bounds.width, startAngle: 0, endAngle: 2 * CGFloat.pi, strokeColor: .black, lineWidth: 1, fillColor: fillColor ?? .black, clockWise: true)
        self.layer.addSublayer(handViewLayer)
        self.layer.addSublayer(centralLayer)
        handLayer = handViewLayer
        centralCircleLayer = centralLayer
    }
    
    override func defaultHandPath() -> UIBezierPath {
        let handLayerPath = UIBezierPath()
        handLayerPath.move(to: CGPoint(x: bounds.width/3, y: 0))
        handLayerPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        handLayerPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        handLayerPath.addLine(to: CGPoint(x: 2*bounds.width/3, y: 0))
        handLayerPath.close()
        return handLayerPath
    }
}

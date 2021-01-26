//
//  CAShapeLayer+Extension.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

extension CAShapeLayer {
    
    func makeLayer(path: UIBezierPath, lineWidth: CGFloat, fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        self.path = path.cgPath
        self.fillColor = fillColor.cgColor
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor.cgColor
        return self
    }
}

//
//  RoundView.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

class RoundView: UIView, RoundViewProtocol {
    
    override var bounds: CGRect {
        didSet {
            makeViewRounded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViewRounded()
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeViewRounded()
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.clear
        }
    }
}

//
//  RoundViewProtocol.swift
//  AnalogueClock
//
//  Created by Priyesh on 11/01/21.
//

import UIKit

protocol RoundViewProtocol {
    func makeViewRounded()
}

//MARK:- Default implementation for UIView
extension RoundViewProtocol where Self: UIView {
    func makeViewRounded() {
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}

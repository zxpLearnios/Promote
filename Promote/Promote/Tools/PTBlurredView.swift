//
//  PTBlurredView.swift
//  Promote
//
//  Created by Bavaria on 2018/5/31.
//  模糊

import UIKit

class PTBlurredView: UIView {

    convenience init() {
        self.init(frame: .zero)
        
    }
    
    private func setup() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .blackTranslucent
    }

}

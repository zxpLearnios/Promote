//
//  PTTabBar.swift
//  Promote
//
//  Created by bavaria on 2018/4/20.
//

import UIKit

class PTTabBar: UITabBar {

    
    convenience init() {
        self.init(frame: .zero)
        // 此时背景色只能在此设置
        backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

}

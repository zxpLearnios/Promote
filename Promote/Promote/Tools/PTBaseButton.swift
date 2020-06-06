//
//  PTBaseButton.swift
//  Promote
//
//  Created by Bavaria on 2018/5/31.
//

import UIKit


private var tapTimeIntervalKey = 0
private var tapEnableKey = 0


class PTBaseButton: UIButton {

    var tapCallback: ((PTBaseButton) -> Void)?
    
    
    
    convenience init() {
        self.init(frame: .zero)
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc private func tapAction() {
        if let callback = tapCallback {
            callback(self)
        }
    }
    
    /// 额外的点击区域，负值：增加了区域
    var tapEdgeInsets: UIEdgeInsets?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden {
            return false
        }
        
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden {
            return super.point(inside: point, with: event)
        }
        
        if let tapInsets = tapEdgeInsets {
            let relativeFrame = bounds
            let newFrame = relativeFrame.inset(by: tapInsets)
            return newFrame.contains(point)
        }
        return frame.contains(point)
    }

    
    
    
}


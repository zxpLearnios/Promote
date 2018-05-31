//
//  PTBaseButton.swift
//  Promote
//
//  Created by Bavaria on 2018/5/31.
//

import UIKit

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
    

}

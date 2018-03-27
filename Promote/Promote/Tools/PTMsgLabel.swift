//
//  QKErrorLabel.swift
//  test_swiftSecond
//
//  Created by Jingnan Zhang on 16/4/5.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit

class PTMsgLabel: UILabel {

    
    private var count: Int = 0
    private var height: CGFloat {
        return 18
    }
    
    private var _errorMessage: String?
    /** 错误信息 */
    var errorMessage: String? {
        get {
            return self._errorMessage
        }
        set {
            self._errorMessage = newValue
            self.text = self._errorMessage
            if self.isHidden {
                self.isHidden = false;
            }
            if count == 0 {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    //执行动画, 改变Y值  没用
                    UIView.animate(withDuration: 0.6, animations: { () -> Void in
                        self.count = 1
                        self.transform = CGAffineTransform(translationX: 0, y: self.height)
                        }, completion: { (finished) -> Void in
                            UIView.animate(withDuration: 0.6, delay: 2, options:.curveLinear, animations: { () -> Void in
                                self.transform = CGAffineTransform.identity
                                }, completion: { (finished) -> Void in
                                    self.isHidden = true
                                    self.count = 0
                            })
                    })

                })
            }

        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.doThing()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // 调用父类构造器前，须初始化所有自己属性
        self.doThing()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func doThing() {
        self.font = UIFont.systemFont(ofSize: 12)
        self.textColor = UIColor.white
        self.backgroundColor = UIColor.orange
        self.textAlignment = NSTextAlignment.center
    }

}

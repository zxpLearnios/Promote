//
//  QLCaptchaButton.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  验证码按钮, 外部初始化，并设置start即可

import UIKit

class PTCaptchaButton: UIButton {

    private var isNextRunLoop = false
    private var countTimer:Timer!
    private var count = 59
    
    /** 开始递减 */
    var isStart: Bool = false {
        didSet{
            if isStart { // 开启
                doInitTimer()
            }else{ // 关闭
//                stopTimer()
            }
        
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func doInitTimer(){
       countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDecline), userInfo: nil, repeats: true)
        RunLoop.current.add(countTimer, forMode: .common)
    }
    
//    private func stopTimer(){
//        if countTimer != nil {
//            countTimer.invalidate()
//            countTimer = nil
//        }
//    }
    
    // MARK: 数字减少的定时器
    @objc private func countDecline(){
        if !isNextRunLoop {
            if count >= 1 {
                self.isEnabled = false
                self.setTitle("\(count)秒", for: .disabled)
            }
            if count == 0 {
                countTimer.invalidate()
                self.isEnabled = true
                self.setTitle("获取验证码", for: .normal)
                isNextRunLoop = true
            }
            count -= 1
        }
        else{
            count = 59
            isNextRunLoop = false
        }
    }

    
}

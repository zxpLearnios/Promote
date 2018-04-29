//
//  CLHUD.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  外部只需init之后，即可使用

import PKHUD
import UIKit

class PTHUD: NSObject {
    fileprivate let timeOut = 1.8
    
    fileprivate static let hud = PTHUD()
    class var shareInstance: PTHUD {
        return hud
    }
    
    override init() {
        HUD.dimsBackground = true
        // 不允许交互
        HUD.allowsInteraction = false
    }
    
    /**
     1. 展示成功或失败，只有图片
     */
    func showSuccessOrErrorByImage(_ isSuccess: Bool) {
        if isSuccess {
            HUD.flash(.success, delay: timeOut)
        } else {
            HUD.flash(.error, delay: timeOut)
        }
    }
    
    /**
     2. 展示提醒文字
     */
    func showPromptText(_ text: String) {
        HUD.flash(.label(text), delay: timeOut)
    }
    
    /**
     3. 展示提示文字和静态图片, 成功、失败的图片在里面已设置好了
     */
    func showPromptText(_ isSuccess: Bool, text: String) {
        if isSuccess {
            HUD.flash(.labeledImage(image: UIImage(named: "progress"), title: "", subtitle: text), delay: timeOut)
        } else {
            HUD.flash(.labeledImage(image: UIImage(named: "progress"), title: "", subtitle: text), delay: timeOut)
        }
    }
    
    /**
     *  4. 展示正在加载, 须调hidden方法使其隐藏
     */
    func showLoadingProgress() {
        // 它默认的菊花进度
//        HUD.flash(.Progress)
        HUD.show(.labeledRotatingImage(image: UIImage(named: "progress"), title: "", subtitle: "正在加载..."))
    }
    
    /**
     *  5. 展示成功或失败时的文字和动态图片，外部传入文字
     */
    func showSuccessOrError(_ isSuccess: Bool, text: String) {
        if isSuccess {
            HUD.flash(.labeledSuccess(title: "", subtitle: text), delay: timeOut)
        } else {
            HUD.flash(.labeledError(title: "", subtitle: text), delay: timeOut)
        }
    }
    
    /**
     *  6. 隐藏
     */
    func hidden(_ afterDelay: Double) {
        HUD.hide(afterDelay: afterDelay, completion: nil)
    }
}

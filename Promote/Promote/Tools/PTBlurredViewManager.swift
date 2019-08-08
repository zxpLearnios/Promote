//
//  PTBlurredView.swift
//  Promote
//
//  Created by Bavaria on 2018/5/31.
//  模糊

import UIKit
import Cartography

class PTBlurredViewManager {

    enum PTBlurredViewType {
        case toolbar, effectView
    }
    
    private var toolbar: UIToolbar?
    private var effectView: UIVisualEffectView?
    private var type = PTBlurredViewType.effectView

    /// 模糊
    init(with view: UIView, blurredType: PTBlurredViewType = .effectView) {
        self.type = blurredType
        
        if type == .toolbar {
            toolbar = UIToolbar()
            toolbar?.barStyle = .blackTranslucent
            view.addSubview(toolbar!)
            if view.frame.size != .zero {
                toolbar!.frame = view.bounds
            } else {
                constrain(toolbar!) { (tl) in
                    let sv = tl.superview!
                    tl.edges == sv.edges
                }
            }
            
        } else if type == .effectView {
            // dark(黑)  extraLight(白亮)  light(普通白)
            let effect = UIBlurEffect(style: .dark)
            effectView = UIVisualEffectView(effect: effect)
            view.addSubview(effectView!)
            effectView!.frame = view.bounds
            if view.frame.size != .zero {
                effectView!.frame = view.bounds
            } else {
                constrain(effectView!) { (ev) in
                    let sv = ev.superview!
                    ev.edges == sv.edges
                }
            }
        }
        
        
    }
    
    func removeBlurred() {
        if type == .toolbar {
            toolbar?.removeFromSuperview()
        } else if type == .effectView {
            effectView?.removeFromSuperview()
        }
    }
    
}

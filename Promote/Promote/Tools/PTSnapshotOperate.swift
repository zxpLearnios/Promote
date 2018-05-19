//
//  PTSnapshotOperate.swift
//  Promote
//
//  Created by Bavaria on 2018/5/8.
//  截图须知： 1. self.drawHierarchy虽然比layer渲染速度快，但是处理超长视图时无法得到其图片，这是需要用Layer的渲染函数来处理。2，对于地图视图，如果用Layer渲染的方法，得到是黑色图片，必须用UIView的描画函数。

import UIKit

class PTSnapshotOperate {

    
    func addLimitSnapshotView(inView: UIView, at point: CGPoint = .zero) {
        
    }
    
    /**
     * 获取当前屏幕截图
     */
    func getSnapshot(in view: UIView, isContainSafeRect: Bool = true) -> UIImage? {
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        if !isContainSafeRect {
            if #available(iOS 11, *) {
                top = view.safeAreaInsets.top
                bottom = view.safeAreaInsets.bottom
            } else {
                top = 0
                bottom = 0
            }
        }
        
        
        let cutView = view
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cutView.bounds.size.width, height: cutView.bounds.size.height - top - bottom), false, 0)
        //        if let ctx = UIGraphicsGetCurrentContext() {
        //            cutView.layer.render(in: ctx)
        //        }
        // 消除因view层级而带来的黑色阴影
        // afterScreenUpdates true:包含最近的屏幕更新内容, false:不包含刚加入视图层次但未显示的内容
        cutView.drawHierarchy(in: cutView.bounds, afterScreenUpdates: true)
        let cutScreenImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cutScreenImg
    }
}

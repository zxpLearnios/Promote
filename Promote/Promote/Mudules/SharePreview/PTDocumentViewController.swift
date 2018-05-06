//
//  PTDocumentViewController.swift
//  Promote
//
//  Created by bavaria on 2018/5/6.
//  显示所有能打开此文件类型的app列表。并带有quick look \ 快速预览功能


import UIKit
import QuickLook


class PTDocumentViewController: UIDocumentInteractionController, UIDocumentInteractionControllerDelegate {
    private var vc: UIViewController!
    
    convenience init(_ vc: UIViewController, fileUrl: URL?, isQuickLook: Bool = true) {
        self.init()
        self.vc = vc
        url = fileUrl
        
        if isQuickLook {
            // 必须设置。才会带quick look功能
            delegate = self
            // 弹出可以打开文件的app列表和带quick look功能的列表
            presentOptionsMenu(from: kBounds, in: vc.view, animated: true)
            // 控制点击quick look，弹出文件预览页面
            presentPreview(animated: true)
        } else {
            // 弹出可以打开文件的app列表, 不带quick look
            presentOpenInMenu(from: kBounds, in: vc.view, animated: true)
        }
    }
    
    override init() {
        super.init()
    }
    
//     此代理方法主要是用来指定在哪里展示Quick Look预览内容
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return vc
    }
    
    // 此2法无用
//        func documentInteractionControllerRectForPreview(_ controller: UIDocumentInteractionController) -> CGRect {
//            return  CGRect.init(x: 50, y: 100, width: 300, height: 300)
//        }
//
//        //
//        func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
//            let redView = UIView()
//            redView.backgroundColor = .red
//            view.addSubview(redView)
//            return redView
//        }
    //
    
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        //        previewVc.dismiss(animated: false, completion: nil)
//        navigationController?.popViewController(animated: true)
    }
    
    func documentInteractionControllerWillPresentOpenInMenu(_ controller: UIDocumentInteractionController) {
    }
}

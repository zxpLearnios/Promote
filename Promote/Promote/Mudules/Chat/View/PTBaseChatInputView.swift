//
//  PTBaseChatInputView.swift
//  Promote
//
//  Created by bavaria on 2018/5/19.
//

import UIKit

class PTBaseChatInputView: UITextView {

    /** 是否是上移 */
    var frameChangeClosure: ((Bool, CGFloat, Double) -> Void)?
    
    convenience init() {
        let textContainer = NSTextContainer.init(size: CGSize(width: 200, height: 100))
        self.init(frame: .zero, textContainer: textContainer)
        
        delegate = self
        
        PTBaseNotificateAdaptor.addNotification(with: self, method: #selector(keyboardWillShow(noti:)), notificateName: NSNotification.Name.UIKeyboardWillShow)
        PTBaseNotificateAdaptor.addNotification(with: self, method: #selector(keyboardWillHide(noti:)), notificateName: NSNotification.Name.UIKeyboardWillHide)
    }
    
    @objc private func keyboardWillShow(noti: Notification) {
        if let notiDic = noti.userInfo {
            if let keyboardF = notiDic[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                let duration = notiDic[UIKeyboardAnimationDurationUserInfoKey] as? Double
                let t = duration ?? 0.25
                let h = keyboardF.height
                UIView.animate(withDuration: t) { [weak self] in
                    if let `self` = self {
                        self.transform = CGAffineTransform(translationX: 0, y: -h)
                        
                    }
                    
                }
                self.frameChangeClosure?(true, self.transform.ty, t)
            }
            
           
        }
        
        
    }
    
    @objc private func keyboardWillHide(noti: Notification) {
        if let notiDic = noti.userInfo {
            let duration = notiDic[UIKeyboardAnimationDurationUserInfoKey] as? Double
            
            let t = duration ?? 0.25
            UIView.animate(withDuration: t) { [weak self] in
                if let `self` = self {
                    self.transform = CGAffineTransform.identity
                }
                
            }
            
            self.frameChangeClosure?(false, self.transform.ty, t)
        }
    }
    
    deinit {
        PTBaseNotificateAdaptor.removeNotification(with: self, notificateName: NSNotification.Name.UIKeyboardWillShow)
        PTBaseNotificateAdaptor.removeNotification(with: self, notificateName: NSNotification.Name.UIKeyboardWillHide)
    }
    
    
}

extension PTBaseChatInputView: UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    
    
}


//
//  PTBaseChatInputView.swift
//  Promote
//
//  Created by bavaria on 2018/5/19.
//

import UIKit
import Cartography


class PTBaseChatInputView: UIView {
    
    /** 是否是上移 */
    var frameChangeClosure: ((Bool, CGFloat, Double) -> Void)?
    
    let audioBtn = UIButton()
    let textInputView = UITextView()
    let emotionBtn = UIButton()
    let addBtn = UIButton()
    
    convenience init() {
        self.init(frame: .zero)
        setup()
        setSubViews()
    }
    
    private func setup() {
        
        PTBaseNotificateAdaptor.addNotification(with: self, method: #selector(keyboardWillShow(noti:)), notificateName: NSNotification.Name.UIKeyboardWillShow)
        PTBaseNotificateAdaptor.addNotification(with: self, method: #selector(keyboardWillHide(noti:)), notificateName: NSNotification.Name.UIKeyboardWillHide)
    }
    
    private func setSubViews() {
        if subviews.count != 0 {
            return
        }
        
        backgroundColor = UIColor.colorWithHexString("F5F5F5")
        addSubview(audioBtn)
        addSubview(textInputView)
        addSubview(emotionBtn)
        addSubview(addBtn)
        
        audioBtn.setBackgroundImage(#imageLiteral(resourceName: "base_chat_iuput_leftAudio"), for: .normal)
        emotionBtn.setBackgroundImage(#imageLiteral(resourceName: "base_chat_input_emoji"), for: .normal)
        addBtn.setBackgroundImage(#imageLiteral(resourceName: "base_chat_input_add"), for: .normal)
        
        let textContainer = NSTextContainer.init(size: CGSize(width: 200, height: 100))
//        inputView.textContainer = textContainer
        textInputView.delegate = self
        textInputView.layer.cornerRadius = 3
        textInputView.font = UIFont.systemFont(ofSize: 16)
        
        constrain(audioBtn, textInputView, emotionBtn, addBtn, block: {audioBtn, inputView, emotionBtn, addBtn in
            let sv = audioBtn.superview!
            audioBtn.width == 30
            audioBtn.height == 30
            audioBtn.left == sv.left + 10
            audioBtn.bottom == sv.bottom - 10
            
            inputView.left == audioBtn.right + 10
            inputView.right == emotionBtn.left - 10
            inputView.top == sv.top + 10
            inputView.bottom == sv.bottom - 10
            
            
            emotionBtn.width == audioBtn.width
            emotionBtn.height == audioBtn.height
            
            addBtn.width == audioBtn.width
            addBtn.height == audioBtn.height
            
            addBtn.right == sv.right - 10
            emotionBtn.right == addBtn.left - 10
            
            align(bottom: audioBtn, emotionBtn, addBtn)
        })
        
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


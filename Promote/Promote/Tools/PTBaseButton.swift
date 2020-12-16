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
    
    var isBoldFont = false {
        didSet {
            updateFont()
        }
    }
    
    var fontSize: CGFloat = 14 {
        didSet {
            updateFont()
        }
    }
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    var backgroundImage: UIImage? {
        didSet {
            setBackgroundImage(backgroundImage, for: .normal)
        }
    }
    var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
        }
    }
    
    var titleAlignment: NSTextAlignment = .center {
        didSet {
            titleLabel!.textAlignment = titleAlignment
        }
    }
    
    
    /// 额外的点击区域，负值：增加了区域
    var tapEdgeInsets: UIEdgeInsets?
    
    //    convenience init() {
    //        self.init(frame: .zero)
    //        setup()
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setup() {
        updateFont()
        addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    
    func setTitleColor(normal ncolor: UIColor, select sColor: UIColor)  {
        setTitleColor(ncolor, for: .normal)
        setTitleColor(sColor, for: .selected)
    }
    
    @objc private func clickAction() {
        if let closure = tapCallback {
            closure(self)
        }
    }
    
    
    private func updateFont() {
        if isBoldFont {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden {
            return false
        }
        
        if !isUserInteractionEnabled || alpha <= 0.01 || isHidden {
            return super.point(inside: point, with: event)
        }
        
        if let tapInsets = tapEdgeInsets {
            let relativeFrame = bounds
            relativeFrame.inset(by: tapInsets)
            let newFrame =  relativeFrame.inset(by: tapInsets)
            return newFrame.contains(point)
        }
        return bounds.contains(point)
    }

}

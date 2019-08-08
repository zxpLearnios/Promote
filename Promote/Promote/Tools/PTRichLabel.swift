//
//  PTRichLable.swift
//  Promote
//
//  Created by Bavaria on 2018/5/17.
//  可以得到 正确行高的label

import UIKit

class PTRichLabel: UILabel {

    var lineSpace: CGFloat = 10
    var wordSpace: CGFloat = 10
    
    convenience init() {
        self.init(frame: .zero)
        text = "123123aaccacASFGGR这世俗化http://www.baidu.com"
        setup()
    }
    
    
    private func setup() {
        backgroundColor = .white
        numberOfLines = 0
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 3))
        
        
        
        let attributeStr = NSMutableAttributedString.init(string: text!)
        let range = NSRange.init(location: 0, length: text!.count)
        
        
        let mutableParagraphStyle = NSMutableParagraphStyle()
        
        
//        NSTextStorage
        let x = NSDecimalNumber.init()
//        let charactSet = Character
//        let textTab = NSTextTab.init(textAlignment: .natural, location: 10, options: [NSTextTab.OptionKey.columnTerminators: x])
        // 首行的缩进
//        mutableParagraphStyle.firstLineHeadIndent = 1 * 15
//         // 其他行的缩进
//        mutableParagraphStyle.headIndent = 1 * 15
        // 行高倍数
//        mutableParagraphStyle.lineHeightMultiple =
//        paragraph.tailIndent
//        baseWritingDirection
//        mutableParagraphStyle.addTabStop(textTab)
        mutableParagraphStyle.lineBreakMode = .byCharWrapping
        
        
        // 每行字 的上下默认都有写间距
        // font!.lineHeight,包含了每行字默认的上下边距
        let defaultLineWordInset = font!.lineHeight - font!.pointSize
        let realLineSpace = lineSpace - defaultLineWordInset
        mutableParagraphStyle.lineSpacing = realLineSpace
        
        let attributeDic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.paragraphStyle: mutableParagraphStyle,
            NSAttributedStringKey.kern: 10, // 字间距
            NSAttributedStringKey.font: font!,
//            NSAttributedStringKey.backgroundColor: UIColor.white
        ]
        attributeStr.addAttributes(attributeDic, range: range)
        
        attributedText = attributeStr
    }

}

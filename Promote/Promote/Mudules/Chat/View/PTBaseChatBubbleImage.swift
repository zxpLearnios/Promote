//
//  PTBaseChatBgImage.swift
//  Promote
//
//  Created by bavaria on 2018/5/19.
//

import UIKit

// MARK: 聊天气泡
class PTBaseChatBubbleImage: UIImage {
    
//    static func `init`(isForMe: Bool) -> UIImage {
//
//        let meImg = #imageLiteral(resourceName: "base_chat_me")
//        let otherImg = #imageLiteral(resourceName: "base_chat_other")
//        var newImg = UIImage()
//        if isForMe {
//            let left = Int(meImg.size.width * 0.1)
//            let top = Int(meImg.size.height * 0.9)
//            newImg = UIImage.stretch(image: meImg, with: left, topCap: top)
//        } else {
//            let left = Int(otherImg.size.width * 0.9)
//            let top = Int(otherImg.size.height * 0.9)
//            newImg = UIImage.stretch(image: otherImg, with: left, topCap: top)
//        }
//
//        return newImg
//    }
    
    static func initWith(isForMe: Bool) -> UIImage {
        
        let meImg = #imageLiteral(resourceName: "base_chat_me")
        let otherImg = #imageLiteral(resourceName: "base_chat_other")
        var newImg = UIImage()
        if isForMe {
            let left = Int(meImg.size.width * 0.1)
            let top = Int(meImg.size.height * 0.9)
            newImg = UIImage.stretch(image: meImg, with: left, topCap: top)
        } else {
            let left = Int(otherImg.size.width * 0.9)
            let top = Int(otherImg.size.height * 0.9)
            newImg = UIImage.stretch(image: otherImg, with: left, topCap: top)
        }
        
        return newImg
    }
    
    
}

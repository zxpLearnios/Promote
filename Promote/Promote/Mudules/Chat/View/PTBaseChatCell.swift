//
//  PTBaseChatCell.swift
//  Promote
//
//  Created by bavaria on 1018/5/18.
//

import UIKit
import Cartography


class PTBaseChatCell: UITableViewCell {
    
    
    let meBubbleImg = PTBaseChatBubbleImage.initWith(isForMe: true)
    let otherBubbleImg = PTBaseChatBubbleImage.initWith(isForMe: false)
    
    let avatarImgV = UIImageView()
    let bubbleImgV = UIImageView()
    let container = UIView()
    let dateLab = PTBaseLabel(with: kfontBlackColor, fontSize: 10)
    let contentLab = PTBaseLabel(with: .black, fontSize: 16)
    
    let constrainGroup = ConstraintGroup()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
//        debugPrint("reuseIdentifier")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupSubviews() {
        contentLab.numberOfLines = 0
        dateLab.numberOfLines = 0

        contentLab.textAlignment = .left
        container.backgroundColor = .white
        contentLab.backgroundColor = .gray
        
        addSubview(dateLab)
        addSubview(avatarImgV)
        addSubview(bubbleImgV)
        addSubview(container)
        container.addSubview(contentLab)
        
        // 不会变的那些约束
        constrain(dateLab, avatarImgV, container, contentLab) {dateLab, avatarImgV, container, contentLab in
            let sv = dateLab.superview!
            dateLab.centerX == sv.centerX
            dateLab.top == sv.top + 10
            dateLab.bottom == avatarImgV.top - 10
            
            contentLab.edges == container.edges
            contentLab.width <= 200
        }
    }
    
    func updateUI(isForMe: Bool) {
        if isForMe {
            
            constrain(avatarImgV, bubbleImgV, container, contentLab, replace: constrainGroup) { (avatarImgV, bubbleImgV, container, contentLab) in
                let sv = avatarImgV.superview!
                avatarImgV.right == sv.right - 10
                avatarImgV.width == 40
                avatarImgV.height == avatarImgV.width
                
                align(top: [avatarImgV, bubbleImgV])
                bubbleImgV.right == avatarImgV.left - 10
                bubbleImgV.bottom == sv.bottom - 10
                
                container.edges == inset(bubbleImgV.edges, 10, 10, 10, 15)
            }
        } else {
            constrain(avatarImgV, bubbleImgV, container, contentLab, replace: constrainGroup) { (avatarImgV, bubbleImgV, container, contentLab) in
                let sv = avatarImgV.superview!
                avatarImgV.left == sv.left + 10
                avatarImgV.width == 40
                avatarImgV.height == avatarImgV.width
                
                align(top: [avatarImgV, bubbleImgV])
                bubbleImgV.left == avatarImgV.right + 10
                bubbleImgV.bottom == sv.bottom - 10
                
                
                container.edges == inset(bubbleImgV.edges, 10, 15, 10, 10)
            }
        }
    }
    
    func fillData(chatActorModel: PTChatActorModel?) {
        if let model = chatActorModel {
        
            let isme = model.isSendByMe
            updateUI(isForMe: isme)
            
            dateLab.text = model.msgSendDate
            avatarImgV.backgroundColor = isme ? .red : .blue
            bubbleImgV.image = isme ? meBubbleImg : otherBubbleImg
            contentLab.text = model.msgContent
        }
        
    }
    
}

//
//  PTChatBaseModel.swift
//  Promote
//
//  Created by bavaria on 2018/5/19.
//

import UIKit

enum PTChatActorMsgType {
    case image
    case url
    case video
    case audio
    case `default`
}

class PTChatBaseModel: NSObject {

}

/**
 *  聊天参与者
 */
class PTChatActorModel {
    var isSendByMe = false
    
    var avatarImgUrl = ""
    var userId = 0
    var username = ""
    
    var chatType: PTChatActorMsgType!
    var msgContent = ""
    var msgSendDate = ""
    var msgReciveDate = ""
    
    
}


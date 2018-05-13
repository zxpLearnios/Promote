//
//  PTSprikitView.swift
//  Promote
//
//  Created by bavaria on 2018/5/12.
//

import UIKit
import SpriteKit
import GameplayKit


class PTSpritekitView: SKView {

    let node = SKShapeNode()
    
    convenience init() {
        self.init(frame: .zero)
        
        
    }
    
    func doScaleAnimate() {
//        let move = SKAction.move(to: CGPoint.init(x: 100, y: 50), duration: 2)
//        node.runAction(move)
    }

}

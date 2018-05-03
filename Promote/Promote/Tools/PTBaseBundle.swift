//
//  PTBaseBundle.swift
//  Promote
//
//  Created by Bavaria on 2018/5/3.
//

import UIKit

class PTBaseBundle: NSObject {
    
    static func loadImage(name: String) {
        let scale = kwindow!.screen.scale
        if scale == 2 {
            
        } else if scale == 3 {
            
        } else {
            
        }
        
    }

    
    static func lookforImage(name: String) -> Bool {
        
        var newName = name
        
        if name.count > 1 {
            let nameAry = name.components(separatedBy: ".")
            let firstCmp = nameAry.first!
            let lastCmp = nameAry.last!
            
            kbundle.path(forResource: firstCmp, ofType: lastCmp)
            
        } else {
            if newName.hasPrefix("@2x") {
                let endIndex = newName.index(newName.endIndex, offsetBy: 3)
                newName[]
            } else if newName.hasPrefix("@3x") {
                
            }
            
            let pngPath = kbundle.path(forResource: name, ofType: "png")
            let jpegPath = kbundle.path(forResource: name, ofType: "jpeg")
            
            if pngPath == nil {
                
            }
            
            
        }
        return false
    }
    
    
    
}

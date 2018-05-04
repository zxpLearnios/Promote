//
//  PTBaseBundle.swift
//  Promote
//
//  Created by Bavaria on 2018/5/3.
//

import UIKit

class PTBaseBundle: NSObject {
    
    /**
     * 1. 加载除图片外的文件必须带后缀名
     */
    static func loadFile(name: String) -> String {
        let nameAry = name.components(separatedBy: ".")
        
        if nameAry.count > 1 {
            let lastCmp = nameAry.last!
            if ["png", "jpeg", "jpg"].contains(lastCmp) {
                return loadImage(name: name) 
            } else {
                return kbundle.path(forResource: name, ofType: lastCmp) ?? ""
            }
            
        }
        return ""
    }
    
    /**
     * 2. 加载图片可以不带后缀名
     */
    static func loadImage(name: String)  -> String {
        return lookforImage(name: name) ?? ""
    }

    /**
     * 3. 加载图片、pdf
     */
    static func lookforImage(name: String) -> String? {
        
        let scale = kwindow!.screen.scale
        var newName = ""
        let nameAry = name.components(separatedBy: ".")
        
        if nameAry.count > 1 {
            let firstCmp = nameAry.first!
            let lastCmp = nameAry.last!
            
            newName = firstCmp
            
            if lastCmp == "png" {
                if newName.hasSuffix("@2x") || newName.hasSuffix("@3x") {
                    let endIndex = newName.index(newName.endIndex, offsetBy: -3)
                   
                    let range = Range(endIndex..<newName.endIndex)
                    newName.removeSubrange(range)
                }
                
                if scale == 2 {
                    newName += "@2x"
                } else if scale == 3 {
                    newName += "@3x"
                } else {
                    
                }
            } else {
                
            }
            
            return kbundle.path(forResource: newName, ofType: lastCmp)
            
        } else {
            newName = name
            if newName.hasSuffix("@2x") || newName.hasSuffix("@3x") {
                let endIndex = newName.index(newName.endIndex, offsetBy: -3)
                let range = Range(endIndex..<newName.endIndex)
                newName.removeSubrange(range)
            }
            if scale == 2 { // 找@2x的图片，若无，则使用1x的
                let lookfor2xResult = lookforImage(name)
                if lookfor2xResult {
                    newName += "@2x"
                }
            } else if scale == 3 { // 找@3x的图片，若无，则找2x的，若无，则使用1x的
                let lookfor3xResult = lookforImage(name, isFor3x: true)
                if lookfor3xResult {
                    newName += "@3x"
                } else {
                    let lookfor2xResult = lookforImage(name)
                    if lookfor2xResult {
                        newName += "@2x"
                    }
                }
            } else {
                
            }
            let pngPath = kbundle.path(forResource: newName, ofType: "png")
            let jpegPath = kbundle.path(forResource: newName, ofType: "jpeg")
            let jpgPath = kbundle.path(forResource: newName, ofType: "jpg")
            
            if pngPath != nil {
                return pngPath
            } else if jpegPath != nil {
                return jpegPath
            } else if jpgPath != nil {
                return jpgPath
            } else {
                return nil
            }
            
        }
        
    }
    
    @discardableResult static func lookforImage(_ name: String, isFor3x: Bool = false) -> Bool {
        let imgName = isFor3x ? name + "@3x" : name + "@2x"
        return (kbundle.path(forResource: imgName, ofType: "png") != nil)
    }
    
    
    
}

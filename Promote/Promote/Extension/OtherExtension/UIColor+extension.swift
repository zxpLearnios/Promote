//
//  PTUIColor+extension.swift
//  Promote
//
//  Created by Bavaria on 27/03/2018.
//

import UIKit

extension UIColor {
    
    class func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor.init(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
    }
    
    /**
     16 位颜色  传入：333333
     */
    class func colorWithHexString(_ color: String) -> UIColor!
    {
        var cString: String = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") || cString.hasPrefix("0x") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2))
        }
        if cString.hasPrefix("#") {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if cString.count != 6 {
            return .red
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    }
}

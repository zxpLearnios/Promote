//
//  PTBitMapManager.swift
//  Promote
//
//  Created by 张净南 on 2018/11/23.
//

import UIKit

class PTBitMapManager: NSObject {

    let clWidth = 100
    
    func s() {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let context = CGContext.init(data: nil, width: clWidth * 2, height: clWidth * 2, bitsPerComponent: 32 / 4, bytesPerRow: clWidth * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGImageByteOrderInfo.order32Big.rawValue) {
            
            UIGraphicsPushContext(context)
            
            let str: NSString = "qw2r35ert"
            str.draw(in: CGRect(x: 100, y: 100, width: clWidth, height: clWidth), withAttributes: nil)
            UIGraphicsPopContext()
        }
            
        
    }
    
}

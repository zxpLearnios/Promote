//
//  Promote
//
//  Created by Bavaria on 01/04/2018.
//

import UIKit
//import CoreText



extension UIImage{
    
    /**
     由Iconfont获取图片; 
     1. 当tabbarItem的图片用此法获取时，颜色就会不起作用了，因为tabbar很特殊
     2. 当UIImageView的图片用此法获取时，字体大小就不起作用了，而frame起固定图片尺寸的作用
     - parameter content:    编码后的text 字体样式名字
     - parameter familyName: 字体库  不使用此参数时，此参数取默认
     - parameter size:       字体大小
     - parameter color:      字体颜色    不使用此参数时，此参数取默认
     
     - returns: 图片
     */
    static func if_image(withUniCode content: String, familyName: String = "iconfont", fontSize size: CGFloat, fontColor color: UIColor = UIColor.red) -> UIImage {
        
//        debugPrint("familyName = \(familyName), fontColor = \(color)")
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        var attributes = [
            NSAttributedStringKey.font: color,
            NSAttributedStringKey.paragraphStyle: paragraph
        ]
        
        if let font = UIFont(name: familyName, size: size) {
            attributes[NSAttributedStringKey.font] = font
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        
        content.draw(in: CGRect(x: 0, y: 0, width: size, height: size), withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     * 2. 传一张图片，取中间一部分获取一个圆形图片
     */
    static func cr_image(with image: UIImage, size: CGSize) -> UIImage {
        var img = UIImage()
        let drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: size.width, height: size.height), false, 1)
        if let ctx = UIGraphicsGetCurrentContext() {

            ctx.addEllipse(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            ctx.clip()
            ctx.draw(image.cgImage!, in: drawRect)
            img = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return img
    }
}

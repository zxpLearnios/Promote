//
//  Promote
//
//  Created by Bavaria on 01/04/2018.
//

import UIKit


private class Path {
    
    /**
     文件名
     */
    static func basename(_ path: String) -> String {
        return ((path as NSString).lastPathComponent as NSString).deletingPathExtension
    }
    
    /**
     文件的扩展名
     */
    static func extname(_ path: String) -> String {
        return (path as NSString).pathExtension
    }
    
    /**
     文件所在的文件夹名
     */
    static func dirname(_ path: String) -> String {
        return (path as NSString).deletingLastPathComponent
    }
    
    
    
}

extension UIFont {

    /**
     使用时，  最后将字体库放在mainBundle，  这是注册字体的方法之一，此法不如直接在info里面加入此库
    *   let fontPath = "FontAwesome.otf" ， UIFont.register(fontPath)，  之后即可使用此字体库了
     */
    static func register(_ path: String, bundle: Bundle = Bundle.main) {
        
        struct Static {
            static var onceToken: Int = 0
        }
        
        let basename = Path.basename(path)
        
        if UIFont.fontNames(forFamilyName: basename).isEmpty {
            // Ensure single instance
            
//            dispatch_once(&Static.onceToken) {
                let data = getFontData(path, bundle: bundle)
                
                registerGraphicsFont(data)
//            }
        }
    }
    
    
    private static func getFontData(_ path: String, bundle: Bundle) -> Data {
        let basename = Path.basename(path)
        let dirname = Path.dirname(path)
        let extname = Path.extname(path)
        
        if let
            fontURL = bundle.url(forResource: basename, withExtension: extname, subdirectory: dirname),
            let data = try? Data(contentsOf: fontURL)
        {
            return data
        }
        
        fatalError("`\(path)` is not found in \(bundle).")
    }
    
    private static func registerGraphicsFont(_ data: Data) {
        var error: Unmanaged<CFError>?
        if let  provider = CGDataProvider.init(data: data as CFData), let font = CGFont.init(provider) {
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
//             debugPrint(error)
            }
        }
    }

}

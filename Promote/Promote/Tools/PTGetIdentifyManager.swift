//
//  PTPTGetIdentify.swift
//  Promote
//
//  Created by 张净南 on 2018/8/23.
//  1. UIDevice currentDevice] identifierForVendor] UUIDString]  相当于是将app于当前device绑定后生成的，但是删除app后再次安装此值是会变化的
//  2. 然而在iOS 7中苹果再一次无情的封杀mac地址，使用之前的方法获取到的mac地址全部都变成了02:00:00:00:00:00。

import UIKit

class PTGetIdentifyManager {

    // 此剪切板，仅仅用于存储设备的唯一标识
    private let pasteboard = UIPasteboard.init(name: UIPasteboardName(rawValue: "this is just use to save the uniqueIdentify of app"), create: true)! // general
    
    func config() {
        // 永久存在
        
    }
    
    func copyImage(_ image: UIImage?) {
        pasteboard.image = image
    }
    func copyUrl(_ url: URL?) {
        pasteboard.url = url
    }
    func copyContent(_ content: String?) {
        pasteboard.string = content
    }
    
    
    
    func getCopyedImage() -> UIImage? {
        return pasteboard.image
    }
    func getCopyedContent() -> String? {
        return pasteboard.string
        
        // 设置字符串在 本地 剪贴板里, 这样在其他地方就不可见了
//        pasteboard.setItems([["": ""]], options: [UIPasteboardOption.localOnly: true])
//        var indx = IndexSet()
//        indx.insert(1)
        // 为此被存储到剪切板里的内容设置一个过期时间
//        let expriseDate = Date.init(timeInterval: 60 * 60 * 10, since: Date())
//        pasteboard.setItems([["": ""]], options: [UIPasteboardOption.expirationDate: expriseDate])
    }
    func getCopyedUrl() -> URL? {
        return pasteboard.url
    }
    
    
    // MARK: 处理app的唯一识别码
    func handleAppUniqueIdentify() {
        
        let bundleId = getAppBundleId()
        // 可以获取当前设备已经安装的公司下的所有app列表。因为bundleId格式为com.companyName.***
        let aboutIdentifys = bundleId.components(separatedBy: ".")
        // 其实公司的标识，不用获取直接就知道了。
        let companyIdentify = aboutIdentifys[0] + "." + aboutIdentifys[1]
        
        if getCopyedContent() != nil {
            PTPrint("已经存储过uuid了： \( getCopyedContent()!)")
        } else {
            let uniqueIdentify = NSUUID().uuidString
            copyContent(uniqueIdentify)
        }
        
        if let appAndDeviceCreatUUID =  UIDevice.current.identifierForVendor?.uuidString {
            
        }
    }
    
}

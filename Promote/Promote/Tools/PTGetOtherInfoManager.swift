//
//  PTGetOtherInfoManager.swift
//  Promote
//
//  Created by 张净南 on 2018/10/10.
//  获取一些其他信息

import UIKit
import CoreTelephony.CTCarrier
import CoreTelephony.CTTelephonyNetworkInfo
import SystemConfiguration.CaptiveNetwork


class PTGetOtherInfoManager: NSObject {

    /// 判断手机是否越狱
    static func isPhoneHaveRootAccess() -> Bool {
        // 1. 根据越狱后产生的文件判断
        // 越狱后悔产生的文件
//        let jailBrokenFiles = ["/Applications/Cydia.app", "/Library/MobileSubstrate/MobileSubstrate.dylib", "/bin/bash", "/usr/sbin/sshd", "/etc/apt"]
//
//        for subFile in jailBrokenFiles {
//            if FileManager.default.fileExists(atPath: subFile) {
//                PTPrint("手机已经越狱！")
//                return true
//            }
//        }
//        PTPrint("手机未越狱！")
//        return false
        
        // 2. 根据是否能打开cydia判断
//        if let url = URL(string: "cydia://") {
//            if UIApplication.shared.canOpenURL(url) {
//                PTPrint("手机越狱！")
//                return true
//            } else {
//                PTPrint("手机未越狱！")
//                return false
//            }
//        } else {
//            PTPrint("非url")
//            return false
//        }

        // 3. 根据是否能获取所有应用的名称判断
        if (FileManager.default.fileExists(atPath: "User/Applications/")) {
            PTPrint("手机越狱！")
            do {
                let appList = try FileManager.default.contentsOfDirectory(atPath: "User/Applications/")
                PTPrint("已安装的app列表：\(appList)")
            } catch {
                
            }
            
            return true
        }
        PTPrint("手机未越狱！")
        return false
    }
    
    /// 获取运营商信息(IMSI)
    static func getMobileCardOperatorInfo() -> String? {
        // IMSI：International Mobile Subscriber Identification Number 国际移动用户识别码
//        一部分叫MCC(Mobile Country Code
//            移动国家码)，MCC的资源由国际电联(ITU)统一分配，唯一识别移动用户所属的国家，MCC共3位，中国地区的MCC为460
//        另一部分叫MNC(Mobile Network Code 移动网络号码)，用于识别移动客户所属的移动网络运营商。MNC由二到三个十进制数组成，例如中国移动MNC为00、02、07，中国联通的MNC为01、06、09，中国电信的MNC为03、05、11
//
//        由1、2两点可知，对于中国地区来说IMSI一般为46000(中国移动)、46001(中国联通)、46003(中国电信)等
        
        let info = CTTelephonyNetworkInfo()
        let carrier = info.subscriberCellularProvider
        let mobileCountryCode = carrier?.mobileCountryCode
        let mobileNetworkCode = carrier?.mobileNetworkCode
        
        let operatorStr = "\(mobileCountryCode)" + "\(mobileNetworkCode)"
        PTPrint("国际移动用户识别码：\(operatorStr)")
        return operatorStr
    }
    
    /// 获取手机当前连接的WiFi wifi信息ssid和bssid
    static func getCurrentConnectWifiInfo() {
        
        if let supports = CNCopySupportedInterfaces() {
            let maxCount = CFArrayGetCount(supports)
            for i in 0...maxCount-1 {
                let valuePoint =  CFArrayGetValueAtIndex(supports, i)
                // 将指针罗类型转换为对应的类型
                let name = unsafeBitCast(valuePoint, to: CFString.self)
                let cfDic = CNCopyCurrentNetworkInfo(name)
                // CFDictionary获取value
                
                var bssidkey = Unmanaged.passRetained("BSSID" as NSString).autorelease().toOpaque()
                var ssidkey = Unmanaged.passRetained("SSID" as NSString).autorelease().toOpaque()

                if let bssidValuePoint = CFDictionaryGetValue(cfDic!, bssidkey) {
                    let wifiMac = Unmanaged<NSString>.fromOpaque(bssidValuePoint).takeUnretainedValue()
                    PTPrint("当前连接的WiFi的mac地址为：\(wifiMac)")
                }
                if let ssidValuePoint = CFDictionaryGetValue(cfDic!, ssidkey) {
                 let wifiName = Unmanaged<NSString>.fromOpaque(ssidValuePoint).takeUnretainedValue()
                    
                    PTPrint("当前连接的WiFi为：\(wifiName)")
                }
                
            }
            
            
        }
        
        
    }
    
}

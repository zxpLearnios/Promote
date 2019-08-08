//
//  PTGetIpManager.swift
//  Promote
//
//  Created by 张净南 on 2018/8/13.
//  获取当前设备的ip地址

import UIKit
import SystemConfiguration.CaptiveNetwork

import CoreTelephony


class PTGetIpManager {
    
    private static let cellularNetworkManager = CTCellularData()
    
    
    // MARK: 获取ip地址
    static func getIp() {
        let x = PTGetIpByOC()
        let ipDic = x.getIPAddresses()
        let ipv4 = x.getIPAddress(true)
        let ipv6 = x.getIPAddress(false)
        
        let a = getCurrentWifiIp()
        let b = getCurrentWifiIp()
    }
    
    // MARK: 判断手机是否连接蜂窝网络,好像在这里没用
    static func isConnectToCellularNetwork() -> Bool? {
        
        var result: Bool?
        cellularNetworkManager.cellularDataRestrictionDidUpdateNotifier = { cellularNetworkStatus in
            let status = cellularNetworkStatus
            switch status {
            case .restricted: // 关闭
                PTPrint("手机的蜂窝网络: 关闭")
                result = false
            case .notRestricted: // 开启
                PTPrint("手机的蜂窝网络: 开启")
                result = true
            default: // 未知
                PTPrint("手机的蜂窝网络: 未知")
                result = nil
            }
        }
        return result
    }
    
    // MARK: 获取WiFi列表
    static func getWifiList() {
        
    }
    
    // MARK:  获取手机当前所有的网络信息(便于蜂窝网络&个人热点的判断)
    static func getAllIfaName() -> [String] {
        var ifaNames = [String]()
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var temp_addr = ifaddr
            while temp_addr != nil {
                let interface = temp_addr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let ifaName = String.init(utf8String: (interface?.ifa_name)!)
                    if ifaName != nil {
                        ifaNames.append(ifaName!)
                    }
                }
                temp_addr = temp_addr?.pointee.ifa_next
            }
        }
        PTPrint(" 获取手机当前所有的网络信息： \(ifaNames.debugDescription)")
        return ifaNames
    }
    
    
    // MARK: 获取手机当前连接的WiFi网络，不支持模拟器与手机自带网络
    static func getWifiInfo(closure: @escaping ((String, String) -> ())) {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        var bssid = ""
        if interfaces != nil {
            
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    
                    if let ssIdValue = interfaceData["SSID"] as? String { // wifi、网络名字
                         ssid = ssIdValue
                    }
                    if let bssIdValue = interfaceData["BSSID"] as? String { // 服务器标识
                        bssid = bssIdValue
                    }
                }
            }
        }
        
        PTPrint("ssid: \(ssid), bssid: \(bssid) ")
        closure(ssid, bssid)
    }
    
    // MARK: 获取当前连接的WiFi的ip地址， ipv4 ipv6
    static func getCurrentWifiIp() -> String? {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
        
//        var addresses = [String]()
//
//        var interface: UnsafeMutablePointer<ifaddrs>?
//        var ifaddr: UnsafeMutablePointer<ifaddrs>?
//
//        let isSuccess = getifaddrs(&interface)
//        if isSuccess == 0 {
//
//            var ptr = ifaddr
//            while (ptr != nil) {
//                let flags = Int32(ptr!.pointee.ifa_flags)
//                var addr = ptr!.pointee.ifa_addr.pointee
//
//
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//
////                    if let ifName = interface?.pointee.ifa_name.pointee {
////
////                        let  str = String(format: "%d", ifName)
////                        if str == "my-wifi" {
////
////                        }
////                    }
//
//                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String(validatingUTF8:hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//                ptr = ptr!.pointee.ifa_next
//            }
//            freeifaddrs(ifaddr)
//        }
//        return addresses.first
    }

    static func getDNSInfo() {
        
    }
    
}



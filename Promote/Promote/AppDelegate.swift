//
//  AppDelegate.swift
//  Promote
//
//  Created by 张净南 on 2018/3/21.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    let test = PTRxSwiftTest()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        autoreleasepool {
//            debugPrint("fsdfsdffsd \(a)")
//        }
        let us =  UserDefaults.init(suiteName: appGroupskey)!
        us.set("test_appGroups", forKey: "test_app_groups")
        us.synchronize()
        
        
//        kApplication.isStatusBarHidden = false
//        kApplication.isStatusBarHidden = true
        
        isShowGuide()
//        _ = PTCommonTest()
//        Config.shareInstance.networkStatusChanged()

//        window?.rootViewController = PTTestViewController()
//        window?.makeKeyAndVisible()
        
//        testSystemJsonCoderAndEncoder()
//        PTTestAllProtocolManager()
        
        PTGetIpManager.getIp()
//        PTGetIpManager.getWifiInfo(closure: {ssid, bssid  in
//            
//        })
//        PTGetIpManager.isConnectToCellularNetwork()
//        PTGetIpManager.getAllIfaName() //getCurrentWifiIp()
//        PTGetIpManager.isConnectToCellularNetwork()
        
        
//        PTGetIdentifyManager().handleAppUniqueIdentify()
        
        // 获取目录下的所有文件
//        PTFileOperatorManager.getAllFolderWithTheSpecifiedDirectory(kcachesDirectory)
        
        
//        let url = URL.init(fileURLWithPath:  ksavePdfPathkey)
        
//        do {
//
//            let str = try String.init(contentsOfFile: kbundle.path(forResource: "测试适应.txt", ofType: nil)!)
//            let data = try Data.init(base64Encoded: str)!
//
//            try data.write(to: url)
//
//            PTPrint("24234 \(str)")
//        } catch {
//
//        }
        PTGetOtherInfoManager.getCurrentConnectWifiInfo() //getMobileCardOperatorInfo() //isPhoneHaveRootAccess()

        var str = "a"
        var str1 = str
        
        str = "aa"
        str1 = "aa1"
        
        // 测试使用realm创建多个不同的数据库
        
//        let pdr = PTTestRealm.defaultRealm
        delay(1) {
            let ppr = PTTestRealm.peopleRealm
        }
        let peopleA = PTTestRealmPeopleModel()
        peopleA.name = "张三"
        peopleA.age = 22
        let peopleB = PTTestRealmPeopleModel()
        peopleB.name = "defualt"
        peopleB.age = 90
        
        // 数据库只能在当初创建的线程里使用
//        asyncExecuteInSubThread(1) {
//            try? pdr.write {
//                pdr.add(peopleA)
//            }
//        }
//        try? pdr.write {
//            pdr.add(peopleA)
//        }
//        try? ppr.write {
//            ppr.add(peopleB)
//        }
        
//        let namekey = "name"
//        let v = "张三"
//        let operate  = "name == '张三'" // "\(namekey) == '\(v)'"
//        let predicate = NSPredicate.init(format: operate)
//        let ary =  pdr.objects(PTTestRealmPeopleModel.self).filter(predicate)
//    let ary1 =  ppr.objects(PTTestRealmPeopleModel.self).filter(NSPredicate(format: "age == 90"))
        
        // 插入排序
//        let ary = [1, 3.1, 2, 44, 22, 39]
//        testSelectSort(ary: ary) { (result) in
//
//        }
        // 测试deinit的调用链: 子类deinit->父类deinit->根类deinit
        _ =  PTSubTestDeinitCall()
        // 不用第三个变量实现2个数值的交换
        var a = 100
        var b = 200
        a = a^b
        b = a^b
        a = a^b
        
        let testQueue = PTTestQueue()
        testQueue.test()
        
        // 按钮防止重复点击
//        UIButton.swiftLoad()
        
        return true
    }
    
    /// 插入排序 升序
    func testSelectSort(ary: [Double], closure: @escaping(([Double]) -> ())) {
        var newAry = ary
        if newAry.count == 0 {
            closure(newAry)
            return
        }
        
        let count = newAry.count - 1
        for i in 1...count {
            let tmp = newAry[i]
            var leftIndex = i - 1
            while leftIndex >= 0 && newAry[leftIndex] > tmp {
                // 后移
                newAry[leftIndex + 1] = newAry[leftIndex]
                // 从i-1索引开始从右至左遍历
                leftIndex -= 1
            }
            // 添leftindex处的空缺
            newAry[leftIndex+1] = tmp
        }
        closure(newAry)
        
    }
    
    /// jsoncoder jsonEncoder 系统json解析类
    private func testSystemJsonCoderAndEncoder() {
        
        let areaDic: [String : Any] = ["address": "0000", "address_detail": ["country": "中国", "province": "河南", "city": "洛阳", "district": "伊川", "street": "冠名达到", "street_number": "6号"]]
        
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()

        do {
//            var model = PTTestJsonCoderAndEncoderModel (with: "中国", province: "河南", city: "洛阳")
//            model.append(county: "嵩县", town: "洋装", village: "000")
//            let jsonData = try jsonEncoder.encode(model)

            let areaJsonData  = try JSONSerialization.data(withJSONObject: areaDic, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let jsonObj = try jsonDecoder.decode(PTTestJsonCoderAndEncoderModel.self, from: areaJsonData)
            PTPrint("\(jsonObj)")
        } catch let err  {
            PTPrint("\(err)")
        }
    }
}

extension AppDelegate {
    
    
    
    // MARK: 是否是首次使用\当前版本号与已存储的不一致, 只要不一致，就引导
    private func isShowGuide() {
        let previousVersion = kUserDefaults.value(forKey: ksaveAppVersionkey) as? String
        let currentVersion = kbundle.infoDictionary![kappBuildVersionKey] as! String
        
        let guideVC = PTGuideViewController()
        if previousVersion == nil { // 首次使用
            kUserDefaults.setValue(currentVersion, forKey: ksaveAppVersionkey)
            kUserDefaults.synchronize()
            
            window!.rootViewController = guideVC
            window!.makeKeyAndVisible()
        }else{
            if previousVersion! != currentVersion {
                kUserDefaults.setValue(currentVersion, forKey: ksaveAppVersionkey)
                kUserDefaults.synchronize()
                
                window!.rootViewController = guideVC
                window!.makeKeyAndVisible()
            }else{
                if isHaveLogined() {
                    loadHomePage()
                } else {
                    loadLoginPage()
                }
            }
        }
        
    }
    
    private func isHaveLogined() -> Bool{
        let username = kUserDefaults.value(forKey: ksaveUserNamekey) as? String
        return !(username == nil)
    }
    
    private func loadLoginPage() {
        let loginVC =  PTLoginViewController()
        let nav = UINavigationController.init(rootViewController: loginVC)
        window!.rootViewController =  nav
        window!.makeKeyAndVisible()
    }
    
    private func loadHomePage() {
        let homeVC =  PTTabBarController()
        // 不要给TabBarController加导航控制器，因为在ios10会有问题
//        let nav = UINavigationController.init(rootViewController: homeVC)
        window!.rootViewController = homeVC
        window!.makeKeyAndVisible()
    }
    
    func makeSureTheMainRouter() {
        if isHaveLogined() {
            loadHomePage()
        } else {
            loadLoginPage()
        }
    }
}

extension AppDelegate: UIApplicationDelegate {
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    /// 设置准备支持的方向. 必须实现此协议方法才可以使外部设置屏幕至相应方向时有效
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return PTDeviceManager.application(application, supportedInterfaceOrientationsFor: window) // [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscapeLeft]
    }
    
    
     // MARK： iOS9之前
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return true
    }
    
    // MARK： iOS9之后
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        options[sourceApplication]
        // 其他应用发送过来的数据
        return true
    }
}

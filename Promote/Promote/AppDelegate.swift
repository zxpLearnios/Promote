//
//  AppDelegate.swift
//  Promote
//
//  Created by 张净南 on 2018/3/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?
    let test = PTRxSwiftTest()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        autoreleasepool {
//            debugPrint("fsdfsdffsd \(a)")
//        }
        let us =  UserDefaults.init(suiteName: appGroupskey)!
        us.set("test_appGroups", forKey: "test_app_groups")
        us.synchronize()
        
        isShowGuide()
        _ = PTCommonTest()
//        Config.shareInstance.networkStatusChanged()

//        window?.rootViewController = PTTestViewController()
//        window?.makeKeyAndVisible()
        return true
    }

    
}

extension AppDelegate {
    
    // MARK: 是否是首次使用\当前版本号与已存储的不一致, 只要不一致，就引导
    private func isShowGuide() {
        let previousVersion = kUserDefaults.value(forKey: ksaveAppVersionkey) as? String
        let currentVersion = kbundle.infoDictionary![kappVersionKey] as! String
        
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
     // MARK： iOS9之前
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return true
    }
    
    // MARK： iOS9之后
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        options[sourceApplication]
        // 其他应用发送过来的数据
        return true
    }
}

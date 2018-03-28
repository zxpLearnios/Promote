//
//  AppDelegate.swift
//  Promote
//
//  Created by 张净南 on 2018/3/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Config.shareInstance.networkStatusChanged()
        return true
    }

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


}

extension AppDelegate {
    // MARK: 是否是首次使用\当前版本号与已存储的不一致, 只要不一致，就引导
    private func isShowGuide() {
        // 从沙盒里获取以前的版本号
        let previousVersion = kUserDefaults.value(forKeyPath: ksaveAppVersionkey) as? String
        // 当前版本号
        let currentVersion = kbundle.infoDictionary![kappVersionKey] as! String
        
        let guideVC = PTGuideViewController()
        if previousVersion == nil { // 首次使用
            
            // 存储版本号
            kUserDefaults.setValue(currentVersion, forKey: ksaveAppVersionkey)
            kUserDefaults.synchronize()
            
            window!.rootViewController = guideVC
            window!.makeKeyAndVisible()
        }else{
            if previousVersion! != currentVersion { // 当前版本号与已存储的不一致
                // 存储版本号
                kUserDefaults.setValue(currentVersion, forKey: ksaveAppVersionkey)
                kUserDefaults.synchronize()
                
                window!.rootViewController = guideVC
                window!.makeKeyAndVisible()
            }else{ // 当前版本号与已存储的一致 ，看是否已经登陆了
                isHaveLogined()
            }
        }
        
    }
   
    func loadLoginPage() {
        let loginVC =  l()
        let nav = QLNavigationController.init(rootViewController: loginVC)
        window!.rootViewController =  nav
        window!.makeKeyAndVisible()
    }
}

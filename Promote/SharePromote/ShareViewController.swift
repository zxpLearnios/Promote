//
//  ShareViewController.swift
//  SharePromote
//
//  Created by Bavaria on 2018/4/28.
//

import UIKit
import Social



class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 用户可以输入时，用
        //        textView! contentText placeholder
        
        let us = UserDefaults.init(suiteName: appGroupskey)!
        let str = us.value(forKey: "test_app_groups") as? String
        textView.text = str ?? "111"
    }
    
    // 一定要调用super，否则，点取消后，后续无法操作
    override func didSelectCancel() {
        super.didSelectCancel()
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let vc =  PTShareViewController.init(with: extensionContext!, backClosure: {[weak self] in
            self?.cancel()
            // self?.didSelectCancel()
        })
        let sharedVc = PTShareNavigationController.init(rootViewController: vc)
        present(sharedVc, animated: true, completion: nil)

        //        pushConfigurationViewController(vc) // 相当于加item
        
    }
    
    
   
}



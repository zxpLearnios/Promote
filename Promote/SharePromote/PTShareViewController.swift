//
//  PTShareViewController.swift
//  SharePromote
//
//  Created by Bavaria on 2018/4/28.
//

import UIKit
import Social

class PTShareViewController: SLComposeServiceViewController {

    
    private lazy var spaceItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()!
        item.title = "空间"
        item.value = "请选择"
        item.tapHandler = {
            self.spaceItemAction()
        }
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        // navigationController = SLSheetNavigationController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectCancel() {
        
        
    }
    
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return [spaceItem]
    }

   
    
   
    private func spaceItemAction() {
        
    }
    
    
}


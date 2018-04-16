//
//  QLBaseTableViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.

import UIKit

class PTBaseTableViewController: UITableViewController {

    var nav: UINavigationController! // 导航控制器
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.separatorStyle = .none
//        self.tableView.tableFooterView = UIView()
        
        adjustUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: 调整UI
    private func adjustUI() {
        if #available(iOS 11.0, *) {
            self.tableView.contentInset = UIEdgeInsetsMake(-44, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
  
}

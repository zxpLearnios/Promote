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
        self.tableView.separatorStyle = .none
        self.tableView.tableHeaderView = UIView()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

  
}

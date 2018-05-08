//
//  PTBaseListController.swift
//  Promote
//
//  Created by Bavaria on 2018/5/8.
//

import UIKit
import Cartography

class PTBaseListController: UIViewController {

    // 私有的且外部不可修改
//    private private(set) var  tableView: UITableView!
     // 外部不可修改
    private(set) var  tableView: UITableView!
    
    var listStyle: UITableViewStyle = .plain {
        didSet {
            tableView = UITableView.init(frame: .zero, style: listStyle)
        }
    }
    
    convenience init(with style: UITableViewStyle) {
        self.init()
        listStyle = style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        if tableView.style == .grouped {
            let emptyView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.001))
            tableView.tableHeaderView = emptyView
        }
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubview(tableView)
        constrain(tableView) { tv in
            tv.edges == tv.superview!.edges
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}

extension PTBaseListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
}

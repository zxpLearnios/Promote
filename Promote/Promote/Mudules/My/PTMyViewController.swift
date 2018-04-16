//
//  PTMyViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//

import UIKit
import Cartography
import RxCocoa
import RxSwift

class PTMyViewController: PTBaseViewController {

    private let tableView = UITableView.init(frame: .zero, style: .plain)
    private let cellId = "simple_cell"
    
    private var simpleDataSource: [String] = {
        var ary = [String]()
        for i in 0...20 {
            ary.append(String(i))
        }
        return ary
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brown
        setSubviews()
        setSimpleDataSource()
        let a = self.topLayoutGuide
//        self.automaticallyAdjustsScrollViewInsets = false
        
        tableView.rowHeight = 80
    }

    private func setSubviews() {
        addSubview(tableView)
        tableView.tableFooterView = UIView()
//        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
//        tableView.setContentOffset(CGPoint.init(x: 0, y: 10), animated: false)
//        tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        
//        view.safeAreaInsets
        _ = constrain(tableView) { (tv) in
            let sv = tv.superview!
            tv.edges == sv.edges
//            tv.top == sv.safeAreaLayoutGuide.top
//            tv.width == sv.width
//            tv.height == sv.height
//            tv.center == sv.center
        }
     
        tableView.rx.itemSelected.bind { [weak self] _ in
        }
        

    }
    
    /**
     * 设置数据源
     */
    private func setSimpleDataSource() {
        
        /**
         * 此处有一坑，就是Observable.just时，dataSourceOb在bindTo到tableview上时，里面的类型是可以被正确识别的；但是使用其他方式，如：Observable.from([]), Observable.of("1", "")时，类型是不能被正确识别的，此时须在初始化时，显示声明其类型
         */
        // 显示声明Observable的类型
        let dataSourceOb = Observable<[String]>.from(optional: simpleDataSource)
//        let dataSourceOb = Observable.just(["1", "2"])
        
        dataSourceOb.bind(to: tableView.rx.items){ [unowned self] (tv, index, element) in
            var cell = tv.dequeueReusableCell(withIdentifier: self.cellId)
            if cell == nil {
                cell = UITableViewCell.init()
            }
            cell!.textLabel?.text = (index % 2 == 0) ? "simple" : "\(element)"
//            debugPrint("qwrewer  \(index) \(element)")
            return cell!
            }.disposed(by: disposeBag)

    }

    
    
}


extension PTMyViewController {
    
    
}


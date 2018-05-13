//
//  PTBaseListController.swift
//  Promote
//
//  Created by Bavaria on 2018/5/8.
//  简易列表控制器，里面只有一种cell

import UIKit
import Cartography
import RxCocoa
import RxSwift



class PTBasePoorRxListController: UIViewController {

    // 私有的且外部不可修改
//    private private(set) var  tableView: UITableView!
     // 外部不可修改
    private(set) var  tableView: UITableView!
    private let cellId = "test_simple_cell"
    var rowH: CGFloat = 80
    var isHaveMore = false
    
    var listStyle: UITableViewStyle = .plain {
        didSet {
            guard tableView == nil else {
                return
            }
            tableView = UITableView.init(frame: .zero, style: listStyle)
        }
    }
    
    private lazy var simpleDataSource: [String] = {
        var ary = [String]()
        for i in 0...20 {
            ary.append(String(i))
        }
        return ary
    }()
    
    
    
    // 初始化属性时，不会触发属性的didSet
    convenience init(with style: UITableViewStyle) {
        self.init()
        listStyle = style
        tableView = UITableView.init(frame: .zero, style: listStyle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kviewBgColor
        setup()
        setListRxDatasource()
    }

    func setup() {
        tableView.separatorStyle = .none
        if tableView.style == .grouped {
            let emptyView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.001))
            tableView.tableHeaderView = emptyView
        }
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//        if self.conforms(to: UITableViewDataSource.self) {
//            tableView.dataSource = self as! UITableViewDataSource
//        }
        tableView.delegate = self
        
        addSubview(tableView)
        constrain(tableView) { tv in
            tv.edges == tv.superview!.edges
        }
    }
    
    func setListRxDatasource() {
//        let data = Observable<[String]>.from(optional: simpleDataSource)
        
        let a = Observable<[String]>.from(optional: ["00", "01"])
        let b = Observable<[String]>.from(optional: ["02", "03"])
        
        a.bind(to: tableView.rx.items)({[weak self] tv, row, ele in
            if let `self` = self {
                let cell = tv.dequeueReusableCell(withIdentifier: self.cellId)!
                cell.textLabel?.text = "rx 返回的cell" + ele
                return cell
            }
            return UITableViewCell()
        
        }).disposed(by: disposeBag)
        
        b.bind(to: tableView.rx.items)({[weak self] tv, row, ele in
            if let `self` = self {
                let cell = tv.dequeueReusableCell(withIdentifier: self.cellId)!
                cell.textLabel?.text = "rx 返回的cell" + ele
                return cell
            }
            return UITableViewCell()
            
        }).disposed(by: disposeBag)
        
//        data.bind(to: tableView.rx.items){[weak self] (tv, row, element) in
//            if let `self` = self {
//                let cell = tv.dequeueReusableCell(withIdentifier: self.cellId)!
//                cell.textLabel?.text = "rx 返回的cell"
//                return cell
//            }
//            return UITableViewCell()
//        }.disposed(by: disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}

extension PTBasePoorRxListController: UITableViewDelegate {
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return simpleDataSource.count
//    }
    
     // warning:  不能使用此法(cellforRow)绑定数据源，因为会和tableView.rx.items冲突(方法和此有冲突，直接crash)
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "UITableViewDelegate 返回的cell "
//        return cell
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if rowH == 80 {
            rowH = 40
        } else {
            rowH = 80
        }
        tableView.reloadData()
    }
    
}

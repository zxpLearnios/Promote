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

class PTMyViewController: PTBaseViewController { // PTBaseViewController

    private let tableView = UITableView.init(frame: .zero, style: .plain)
    private let cellId = "simple_cell"
    var rowH: CGFloat = 80

    private var simpleDataSource: [String] = {
        var ary = [String]()
        for i in 0...120 {
            ary.append(String(i))
        }
        return ary
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .brown
        setSubviews()
        setSimpleDataSource()
    }



    private func setSubviews() {
        addSubview(tableView)
        tableView.register(PTMyViewControllerCell.self, forCellReuseIdentifier: cellId)

        _ = constrain(tableView) { (tv) in
            let sv = tv.superview!
            tv.edges == sv.edges
            tv.bottom == sv.bottom
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


        dataSourceOb.bind(to: tableView.rx.items){ [weak self] (tv, index, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: (self?.cellId)!) as! PTMyViewControllerCell
            cell.content = (index % 2 == 0) ? "simple" : "\(element)"
            return cell
            }.disposed(by: disposeBag)
    }

    // MARK: 调整UI
    private func adjustUI() {
        if #available(iOS 11.0, *) {
            self.tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}


extension PTMyViewController: UITableViewDelegate {

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

fileprivate class PTMyViewControllerCell: UITableViewCell {
    
    var content = "" {
        didSet {
            contentLab.text = content
        }
    }
    
    private let contentLab = PTBaseLabel(with: .blue, fontSize: 16)
    private let imgV = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(contentLab)
        contentView.addSubview(imgV)
        
        imgV.backgroundColor = .red
        imgV.layer.cornerRadius = 15
//        imgV.alpha = 0.8
        imgV.isOpaque = false
        imgV.layer.shouldRasterize = true
        imgV.layer.masksToBounds = true
        
        constrain(contentLab, imgV) { (lab, iv) in
            let sv = lab.superview!
            
            lab.centerY == sv.centerY
            lab.left == sv.left + 30
            
            iv.centerY == lab.centerY
            iv.right == sv.right - 30
            iv.width == 30
            iv.height == 30
        }
    }
    
}

//
//class PTMyViewController: PTBaseTableViewController {
//
//    private let cellId = "simple_cell"
//    var rowH: CGFloat = 80
//
//    private var simpleDataSource: [String] = {
//        var ary = [String]()
//        for i in 0...20 {
//            ary.append(String(i))
//        }
//        return ary
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//
//        setSimpleDataSource()
//    }
//
//
//
//
//
//
//    /**
//     * 设置数据源
//     */
//    private func setSimpleDataSource() {
//
//        /**
//         * 此处有一坑，就是Observable.just时，dataSourceOb在bindTo到tableview上时，里面的类型是可以被正确识别的；但是使用其他方式，如：Observable.from([]), Observable.of("1", "")时，类型是不能被正确识别的，此时须在初始化时，显示声明其类型
//         */
//        // 显示声明Observable的类型
//        let dataSourceOb = Observable<[String]>.from(optional: simpleDataSource)
//        //        let dataSourceOb = Observable.just(["1", "2"])
//
//
//        // warning: UITableViewController 不能使用此法绑定数据源，因为会和自己冲突(cellforRow方法和此有冲突，直接crash)，UITableViewController的dataSource、delegate默认为自己
//        dataSourceOb.bind(to: tableView.rx.items){ [weak self] (tv, index, element) in
//             var cell = tv.dequeueReusableCell(withIdentifier: (self?.cellId)!)!
//             cell.contentView.backgroundColor = (index % 2 == 0) ? .red : .white
//             cell.textLabel?.text = (index % 2 == 0) ? "simple" : "\(element)"
//             return cell
//            }.disposed(by: disposeBag)
//
//    }
//
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return simpleDataSource.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return rowH
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if rowH == 80 {
//            rowH = 40
//        } else {
//            rowH = 80
//        }
//        tableView.reloadData()
//    }
//
//}





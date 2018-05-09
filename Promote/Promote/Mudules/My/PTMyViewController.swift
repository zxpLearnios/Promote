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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setSubviews()
    }



    private func setSubviews() {
       let animeteV = ProgressVIew.init()
        addSubview(animeteV)
        
        animeteV.frame = CGRect.init(x: 40, y: 140, width: 300, height: 30)
        
    }
    


}


class ProgressVIew: UIView {
    
    let lab = UILabel()
    var capW: CGFloat = 10
    let shapeLayer = CAShapeLayer()
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = .white
        
        layer.addSublayer(shapeLayer)
//        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineJoin = kCALineJoinRound
        // lineWidth必须设置，不然为黑色
        shapeLayer.lineWidth = 10
        shapeLayer.strokeColor = UIColor.gray.cgColor
        
        
        
        
        
//        shapeLayer.backgroundColor = UIColor.red.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
       
        
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 10, y: 10, width: self.capW, height: 0), cornerRadius: 5)
        shapeLayer.path = path.cgPath
        // 1.
//        if let ctx = UIGraphicsGetCurrentContext() {
//
//            UIColor.blue.set()
//            ctx.setLineWidth(10)
//            ctx.setLineCap(.round)
//            ctx.setLineJoin(.round)
//            ctx.move(to: CGPoint.init(x: 0, y: 10))
//            UIView.animate(withDuration: 0.2) {
//                ctx.addLine(to: CGPoint.init(x: self.capW, y: 10))
//                ctx.strokePath()
//            }
//
//        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        capW += 20
        setNeedsDisplay()
        
        
    }
    
}

//
//
//extension PTMyViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return rowH
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if rowH == 80 {
//            rowH = 40
//        } else {
//            rowH = 80
//        }
//        tableView.reloadData()
//    }
//
//}

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
//        // warning: UITableViewController 不能使用此法绑定数据源，因为会和自己冲突，UITableViewController的dataSource、delegate默认为自己
////        dataSourceOb.bind(to: tableView.rx.items){ [weak self] (tv, index, element) in
////             var cell = tv.dequeueReusableCell(withIdentifier: (self?.cellId)!)!
////             cell.contentView.backgroundColor = (index % 2 == 0) ? .red : .white
////             cell.textLabel?.text = (index % 2 == 0) ? "simple" : "\(element)"
////             return cell
////            }.disposed(by: disposeBag)
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
//




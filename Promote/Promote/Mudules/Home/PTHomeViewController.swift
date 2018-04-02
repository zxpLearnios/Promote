//
//  PTHomeViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//

import UIKit
import Cartography


class PTHomeViewController: PTBaseViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        doThing()
        
    }

    func doThing() {
//        let cv = CollectionView.init(frame: CGRect.init(x: 0, y: 200, width: kwidth, height: 100))
//        cv.delegate = self
//        cv.dataSource = self
//        cv.register(Item.self, forCellWithReuseIdentifier: "item_key")
//        kwindow?.addSubview(cv)
//
//        delay(2) {
//
//            UIView.animate(withDuration: 5) {
//                cv.setContentOffset(CGPoint.init(x: 300, y: 0), animated: false)
//            }
//        }
       
        let tv = UITableView()
        
        tv.register(Cell.self, forCellReuseIdentifier: "item_key")
        tv.estimatedRowHeight = 30
        tv.rowHeight = UITableViewAutomaticDimension
        
        tv.delegate = self
        tv.dataSource = self
        kwindow?.addSubview(tv)
        
        
        tv.frame = CGRect.init(x: 0, y: 200, width: 50, height: kwidth)
//        tv.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
        tv.layer.transform = CATransform3DMakeRotation(CGFloat (-M_PI / 2), 0, 0, 1)
        tv.layer.position = CGPoint.init(x: kwidth / 2, y:  150)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item_key", for: indexPath) as! Item
//
//        cell.titleLab.text = String(format: "哼--%d", indexPath.item)
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_key", for: indexPath) as! Cell
        let str = (indexPath.item % 2 == 0) ? "eee": "33333333"
        cell.titleLab.text = str
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("等急了---%d", indexPath.item)
    }
    
}


class CollectionView: UICollectionView {
    
    convenience init (frame: CGRect) {
        let fl = UICollectionViewFlowLayout()
        fl.estimatedItemSize = CGSize.init(width: 100, height: 50)
        fl.minimumInteritemSpacing = 20
        fl.scrollDirection = .horizontal
        fl.minimumLineSpacing = 30 // item之间的距离
        
        self.init(frame: frame, collectionViewLayout: fl)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bounces = false
        backgroundColor = .white
    }
    
}

//class Item: UICollectionViewCell {
//
//
//    let titleLab = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLab.textColor = .purple
//
//        contentView.backgroundColor = .gray
//        contentView.addSubview(titleLab)
//
//        constrain(titleLab) { (lab) in
//            lab.center == lab.superview!.center
//            lab.width == 50
//            lab.height == 30
//        }
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}

class Cell: UITableViewCell {
    
    let titleLab = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLab.numberOfLines = 0
        
        titleLab.preferredMaxLayoutWidth = 30
        titleLab.textAlignment = .center
        titleLab.textColor = .purple

        titleLab.sizeToFit()
        contentView.backgroundColor = .gray
        contentView.addSubview(titleLab)

        constrain(titleLab) { (lab) in
            lab.top == lab.superview!.top + 20
            lab.bottom == lab.superview!.bottom - 20
            
        }
        
//        contentView.layer.anchorPoint = CGPoint.zero
//        titleLab.layer.transform = CATransform3DMakeRotation(CGFloat (M_PI / 2), 0, 0, 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
    
//        titleLab.layer.position = CGPoint.init(x: 25, y:  self.frame.height / 2)
    }
    
}


//
//  PTHomeViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//

import UIKit
import Cartography


class PTHomeViewController: PTBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var  cv: CollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        doThing()
        
    }

    func doThing() {
        cv = CollectionView.init(frame: CGRect.init(x: 0, y: 200, width: kwidth, height: 100))
        cv.delegate = self
        cv.dataSource = self
        cv.register(Item.self, forCellWithReuseIdentifier: "item_key")
        kwindow?.addSubview(cv)
//        let fl = cv.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        cv.contentInset = UIEdgeInsetsMake(0, 100, 0, 0)
        delay(2) {
            let dl = CADisplayLink.init(target: self, selector: #selector(self.handleAnima))
            dl.add(to: RunLoop.main, forMode: .commonModes)
        }
       
        
    }
    
    @objc func handleAnima() {
        DispatchQueue.main.async {
            self.cv.contentInset = UIEdgeInsets.zero
            let x = self.cv.contentOffset.x
            self.cv.setContentOffset(CGPoint.init(x: x + 0.8, y: 0), animated: false)

        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item % 2 == 0 {
            return CGSize.init(width: 200, height: 50)
        } else {
            return CGSize.init(width: 100, height: 50)
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item_key", for: indexPath) as! Item
        let a = (indexPath.item % 2 == 0) ? 11111 + indexPath.item : 22 + indexPath.item
        cell.titleLab.text = String(format: "哼--%d", a)
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("点击了---%d", indexPath.item)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

class Scroller: UIScrollView {
//    let datasource = []
    
    
    
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
//        bounces = false
        backgroundColor = .white
    }
    
}

class Item: UICollectionViewCell {


    let titleLab = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLab.textColor = .purple

        contentView.backgroundColor = .gray
        contentView.addSubview(titleLab)

       let a = constrain(titleLab) { (lab) in
            lab.center == lab.superview!.center
//            lab.width == 50
//            lab.height == 30
        }
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class Cell: UITableViewCell {
    
     let lab = UILabel()
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
//        titleLab.layer.transform = CATransform3DMakeRotation(CGFloat (Double.pi / 2), 0, 0, 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
    
        titleLab.layer.position = CGPoint.init(x: 25, y:  self.frame.height / 2)
        
        contentView.backgroundColor = (tag % 2 == 0) ? .red : .white
        titleLab.isHidden = true
        let x = (50 - titleLab.width) / 2
        let y:CGFloat = 20
        
        if lab.superview != contentView {
            contentView.addSubview(lab)
        }
        lab.text = titleLab.text
        lab.frame = CGRect.init(origin: CGPoint(x: x, y: y), size: CGSize(width: titleLab.height, height: titleLab.width))
        
//        let str = titleLab.text as NSString?
//        str?.draw(in: CGRect.init(origin: CGPoint(x: x, y: y), size: CGSize(width: titleLab.height, height: titleLab.width)), withAttributes: [NSAttributedStringKey.font: titleLab.font])
        
    }
    
}


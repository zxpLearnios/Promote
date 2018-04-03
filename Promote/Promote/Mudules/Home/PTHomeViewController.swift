//
//  PTHomeViewController.swift
//  Promote
//
//  Created by Bavaria on 02/04/2018.
//  分段、可点击的跑马灯，自动循环滚动
//  网上看了使用2个label或自定义横向滚动列表来实现跑马灯效果的，虽然第一种有人也实现了分段、可点击。但是个人感觉还是使用系统自带的CollectionView比较好，因为系统实现了缓存池，个人实现的话，涉及到的东西太多太多。经测试，旋转tableview再旋转tableviewcell是实现不了这样的效果的切连UI都很难实现。故最终使用一个collectionview来实现，类似于banner的实现

import UIKit
import Cartography


class PTHomeViewController: PTBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var  leftCv: CollectionView!
    var  rightCv: CollectionView!
    var leftDisplayLink: CADisplayLink!
    var rightDisplayLink: CADisplayLink!
    let mutiply: CGFloat = 3
    
    let ary: [String] = {
       let a = ["000", "1111111", "22", "333", "444", "555555", "6", "7777"]
        return a
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cyan
        doThing()
        
    }

    func doThing() {
        
        leftCv = CollectionView.init(frame: CGRect.init(x: 0, y: 200, width: kwidth, height: 100))
        leftCv.delegate = self
        leftCv.dataSource = self
        if #available(iOS 11.0, *) {
            leftCv.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        leftCv.register(Item.self, forCellWithReuseIdentifier: "item_key")
        kwindow?.addSubview(leftCv)
        
        
//        rightCv = CollectionView.init(frame: CGRect.init(x: kwidth, y:  leftCv.y, width: kwidth, height: 100))
//
//        rightCv.delegate = self
//        rightCv.dataSource = self
//        rightCv.register(Item.self, forCellWithReuseIdentifier: "item_key")
//        kwindow?.addSubview(rightCv)
        let fl = leftCv.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        let lastElement = ary.last!
        let leftPadding = CGFloat(lastElement.count * 15 + 30 * 2) + 30
//        leftCv.setContentOffset(CGPoint.init(x: leftPadding, y: 0), animated: false)
        self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: -leftPadding, bottom: 0, right: 0)
//        self.leftCv.contentSize = CGSize.init(width: 3000, height: 0)
        
        delay(0.5) {
            self.startTimer()
            
//            self.leftCv.scrollToItem(at: IndexPath.init(row: 3, section: 0), at: .left, animated: false)
            
        }
       
        
    }
    
    private func startTimer() {
        if leftDisplayLink == nil {
            leftDisplayLink = CADisplayLink.init(target: self, selector: #selector(self.handleLeftCollectionViewAnimate))
            leftDisplayLink.add(to: .main, forMode: .commonModes)
        }
    }
    
    private func stopTimer() {
        if leftDisplayLink == nil {
            return
        }
        leftDisplayLink.invalidate()
        leftDisplayLink = nil
    }
    
    
    @objc func handleLeftCollectionViewAnimate() {
        DispatchQueue.main.async {
            let x = self.leftCv.contentOffset.x
            self.leftCv.setContentOffset(CGPoint.init(x: x + self.mutiply, y: 0), animated: false)

        }

    }
    
    @objc func handleRightCollectionViewAnimate() {
        DispatchQueue.main.async {
            let x = self.rightCv.contentOffset.x
            self.rightCv.setContentOffset(CGPoint.init(x: x + self.mutiply, y: 0), animated: false)
            
        }
        
    }
    
    @objc func handleRightCollectionViewFrameAnimate() {
        DispatchQueue.main.async {
            
//            let time = kwidth / (self.mutiply * 60)
//            UIView.animate(withDuration: TimeInterval(time), animations: {
//                self.leftCv.layer.transform = CATransform3DMakeTranslation(-kwidth, 0, 0)
//
//                self.rightCv.layer.transform = CATransform3DMakeTranslation(-kwidth, 0, 0)
//            }, completion: { res in
//                self.leftCv.removeFromSuperview()
//                self.rightCv.frame = CGRect.init(x: 0, y: 200, width: kwidth, height: 100)
//            })
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let index = indexPath.item
        var width: CGFloat

        if indexPath.item == 0 {
            let lastElement = ary.last!
            width = CGFloat(lastElement.count * 15 + 30 * 2)
        } else {
            let currentElement = ary[index - 1]
            width = CGFloat(currentElement.count * 15 + 30 * 2)

        }
        return CGSize.init(width: width, height: 50)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 30
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ary.count + 1
    }
    
  
    
    func lastCell(_ cell: UICollectionViewCell, atIndexPath index: Int)  {
        if index % 2 == 0 { // 最后一个cell从将要显示到完全显示所需要的时间
            let offsetX = leftCv.contentOffset.x
            
           
//            righttDisplayLink.add(to: RunLoop.main, forMode: .commonModes)
//            righttDisplayLink.invalidate()
           
            
        } else {
            
        }
        
//        let frame = leftCv.convert(cell.frame, to: kwindow!)
        
        
//        let dl = CADisplayLink.init(target: self, selector: #selector(self.handleRightCollectionViewFrameAnimate))
        
//        if frame.maxX + 30 >= kwidth { // 最后一个cell已经完全显示
//            let time = kwidth / (self.mutiply * 60)
//
//            let lastElement = ary.last!
//            // item宽度 + item之间的间距
//            let leftPadding = CGFloat(lastElement.count * 15 + 30 * 2) + 30
//            let theSecondsOfShow: Double = Double (leftPadding) / Double (self.mutiply * 60)
//
//
//
//            delay(theSecondsOfShow, callback: { [weak self] in
//                //            dl.add(to: RunLoop.main, forMode: .commonModes)
//                //            self?.leftDisplayLink.isPaused = true
//                //            self?.leftCv.setContentOffset(CGPoint.init(x: leftPadding, y: 0), animated: false)
//
//                let index = IndexPath.init(row: 1, section: 0)
////                self?.leftCv.selectItem(at: index, animated: false, scrollPosition: .left)
//
//                //            self.rightDisplayLink.isPaused = false
//            })
//        }
        
        
//        delay(Double(time) + theSecondsOfShow) {
//            self.rightDisplayLink =  CADisplayLink.init(target: self, selector: #selector(self.handleRightCollectionViewAnimate))
//            self.rightDisplayLink.add(to: .main, forMode: .commonModes)
//        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cl = scrollView as! CollectionView
        let lastIndexPath = IndexPath.init(row: ary.count, section: 0)
        let lastCell = cl.cellForItem(at: lastIndexPath)
        guard lastCell != nil else {
            return
        }
        
        if cl == leftCv {
            // 转换坐标系
            let frame = leftCv.convert(lastCell!.frame, to: kwindow!)
           let maxPoint = CGPoint.init(x: frame.maxX, y: frame.maxY)
            
            if kBounds.contains(maxPoint) { // 最后一个cell已经完全显示
                stopTimer()
                
                let lastElement = ary.last!
                // item宽度 + item之间的间距
                let leftPadding = CGFloat(lastElement.count * 15 + 30 * 2) + 30
//                leftCv.setContentOffset(CGPoint.init(x: leftPadding, y: 0), animated: false)
//                leftCv.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
                leftCv.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .left, animated: false)
                
                delay(0.05, callback: { [weak self] in
                    self?.startTimer()
                })
            }
        }
        
    }
    
    // 先调
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item_key", for: indexPath) as! Item
        
        if indexPath.item == 0 {
            cell.titleLab.text = ary.last
        } else {
            cell.titleLab.text = ary[indexPath.item - 1]
        }
        
        return cell
    }
   
    
    // MARK： - 后调
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if collectionView == leftCv {
            if indexPath.item == ary.count {

                lastCell(cell, atIndexPath: indexPath.item)
                //                debugPrint("将要展示最后一个cell \(cell)")

            }
        } else {

        }


        if cell.frame.maxY >= kwidth {
            debugPrint("第%d个cell已超出边界", indexPath.item)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("点击了---%d", indexPath.item)
    }
    
    
    private func calculateLength(withString str: String) -> CGFloat {
        
        let mutableStr = NSMutableString.init(string: str)
        mutableStr.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 0), options: .usesFontLeading, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil)
        return 1
    }
    
    deinit {
        if leftDisplayLink != nil {
            leftDisplayLink.invalidate()
            leftDisplayLink = nil
        }
        if rightDisplayLink != nil {
            rightDisplayLink.invalidate()
            rightDisplayLink = nil
        }
        
    }
}


class CollectionView: UICollectionView {
    
    convenience init (frame: CGRect) {
        let fl = UICollectionViewFlowLayout()
        // 这里绝对不能要这句
//        fl.estimatedItemSize = CGSize.init(width: 100, height: 50)
        fl.scrollDirection = .horizontal
//        fl.minimumInteritemSpacing = 0 // 水平间距
        fl.minimumLineSpacing = 30 // item 竖直方向的距离
        
        self.init(frame: frame, collectionViewLayout: fl)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        clipsToBounds = false
//        bounces = false
        backgroundColor = .white
        
//        mask = UIView.init(frame: CGRect.init(x: -kwidth, y: 0, width: CGFloat(MAXFLOAT), height: height))
//        mask?.backgroundColor = UIColor.red
    }
    
    
    
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
////        super.point(inside: point, with: event)
//        let userEnableRect = CGRect.init(x: 0, y: 0, width: kwidth * 2, height: height)
//        return userEnableRect.contains(point)
//    }
    
}

class Item: UICollectionViewCell {


    let titleLab = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLab.textColor = .purple

        contentView.backgroundColor = .gray
        contentView.addSubview(titleLab)
        titleLab.font = UIFont.systemFont(ofSize: 15)
        
        constrain(titleLab) { (lab) in
            let superV = lab.superview!
            lab.center == superV.center
//            lab.width == 50
//            lab.height == 30
//            lab.left == superV.left + 30
//
//            lab.right == superV.right - 30
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
//        titleLab.layer.transform = CATransform3DMakeRotation(CGFloat (M_PI / 2), 0, 0, 1)
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



//
//  PTTitleScroller.swift
//  Promote
//
//  Created by Bavaria on 2018/4/3.
//  分段、可点击的跑马灯，自动循环滚动
//  网上看了使用2个label或自定义横向滚动列表来实现跑马灯效果的，虽然第一种有人也实现了分段、可点击。但是个人感觉还是使用系统自带的CollectionView比较好，因为系统实现了缓存池，个人实现的话，涉及到的东西太多太多。经测试，旋转tableview再旋转tableviewcell是实现不了这样的效果的切连UI都很难实现。故最终使用一个collectionview来实现，类似于banner的实现

import UIKit



class PTTitleScroller: UIView {

    var  leftCv: PTTitleScrollerCollectionView!
    var  rightCv: PTTitleScrollerCollectionView!
    var leftDisplayLink: CADisplayLink!
    //    var rightDisplayLink: CADisplayLink!
    let mutiply: CGFloat = 1
    let cellId = "item_key"
    
    var dataSource = [""] {
        didSet {
            guard leftCv == nil else {
                leftCv.reloadData()
                return
            }
            
            doThing()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cyan
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func doThing() {
        
        leftCv = PTTitleScrollerCollectionView.init(frame: bounds)
        addSubview(leftCv)
        
        leftCv.delegate = self
        leftCv.dataSource = self
        if #available(iOS 11.0, *) {
            leftCv.contentInsetAdjustmentBehavior = .never
        } else {
//            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        leftCv.register(PTTitleScrollerCell.self, forCellWithReuseIdentifier: cellId)
        
        let lastElement = dataSource.last!
        let leftPadding = CGFloat(lastElement.count * 15 + 30 * 2) + 30
        //        leftCv.setContentOffset(CGPoint.init(x: leftPadding, y: 0), animated: false)
        self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: -leftPadding, bottom: 0, right: 0)
        //        self.leftCv.contentSize = CGSize.init(width: 3000, height: 0)
        
        delay(0.5) {
            self.startTimer()
        }
        
    }
    
    
    
    
    private func startTimer() {
        if leftDisplayLink == nil {
            
            //            leftDisplayLink = Timer.init(timeInterval: 0.5, target: self, selector: #selector(handleLeftCollectionViewAnimate), userInfo: nil, repeats: true)
            //            RunLoop.main.add(leftDisplayLink, forMode: .commonModes)
            leftDisplayLink = CADisplayLink.init(target: self, selector: #selector(self.handleLeftCollectionViewAnimate))
            leftDisplayLink.add(to: .main, forMode: .common)
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
    
    
    
    private func calculateLength(withString str: String) -> CGFloat {
        
        let mutableStr = NSMutableString.init(string: str)
        mutableStr.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 0), options: .usesFontLeading, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
        return 1
    }
    
    private func lastCell(_ cell: UICollectionViewCell, atIndexPath index: Int)  {
//        if index % 2 == 0 { // 最后一个cell从将要显示到完全显示所需要的时间
//            let offsetX = leftCv.contentOffset.x
//
//
//            //            righttDisplayLink.add(to: RunLoop.main, forMode: .commonModes)
//            //            righttDisplayLink.invalidate()
//
//
//        } else {
//
//        }
        
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
    
    
    deinit {
        if leftDisplayLink != nil {
            leftDisplayLink.invalidate()
            leftDisplayLink = nil
        }
        
    }
    
   
}

extension PTTitleScroller: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let index = indexPath.item
        var width: CGFloat
        
        if indexPath.item == 0 {
            let lastElement = dataSource.last!
            width = CGFloat(lastElement.count * 15 + 30 * 2)
        } else {
            let currentElement = dataSource[index - 1]
            width = CGFloat(currentElement.count * 15 + 30 * 2)
            
        }
        return CGSize.init(width: width, height: height)
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
        return dataSource.count + 1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cl = scrollView as! PTTitleScrollerCollectionView
        let lastIndexPath = IndexPath.init(row: dataSource.count, section: 0)
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
                
                let lastElement = dataSource.last!
                // item宽度 + item之间的间距
                let leftPadding = CGFloat(lastElement.count * 15 + 30 * 2) + 30
                //                leftCv.setContentOffset(CGPoint.init(x: leftPadding, y: 0), animated: false)
                leftCv.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
//                leftCv.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: .left, animated: false)
                
                delay(0.25, callback: { [weak self] in
                    self?.startTimer()
                })
            }
        }
        
    }
    
    // 先调
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PTTitleScrollerCell
        
        if indexPath.item == 0 {
            cell.titleLab.text = dataSource.last
        } else {
            cell.titleLab.text = dataSource[indexPath.item - 1]
        }
        
        return cell
    }
    
    
    // MARK： - 后调
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == leftCv {
            if indexPath.item == dataSource.count {
                
                lastCell(cell, atIndexPath: indexPath.item)
                //                debugPrint("将要展示最后一个cell \(cell)")
                
            }
        } else {
            
        }
        
        
        if cell.frame.maxY >= kwidth {
//            debugPrint("第%d个cell已超出边界", indexPath.item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        debugPrint("点击了---%d", indexPath.item)
    }
    
}









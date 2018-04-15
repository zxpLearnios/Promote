//
//  PTRichTitleScroller.swift
//  Promote
//
//  Created by bavaria on 2018/4/5.
//  1. 由于PTTitleScroller不能最好的实现效果，故我选择使用2个collectionView来实现分段、无限循环滚动、可点击的跑马灯。
//  2. 禁止用户滚动，允许用户滚动的话时需要处理很多事情
//  3. 内部自动处理是否需要滚动，外部只需设置数据源和UI即可
//  4. 其实异步数据处理，就算是banner也一样难以处理，比如banner正在滚动或用户正在滑动，新数据源来了，你怎么办，更新？那UI有可能会瞬间乱掉的。banner的情况比这个简单的多

import UIKit

class PTRichTitleScroller: UIView {

    enum ScrollDirection: Int {
        case left = 0, right
    }
    
    
    private var  leftCv: PTTitleScrollerCollectionView = {
        let cl = PTTitleScrollerCollectionView.init(frame: .zero)
        return cl
    }()
    
    private var  rightCv: PTTitleScrollerCollectionView = {
        let cl = PTTitleScrollerCollectionView.init(frame: .zero)
        return cl
    }()
    
    private var leftDisplayLink: CADisplayLink!
    private var rightDisplayLink: CADisplayLink!
    /** 速度系数，可以自行调节 */
    private let mutiply: CGFloat = 2
    /** cell的间距，可以自行设置 */
    private let itemGap: CGFloat = 30
    /** item里的label距左右的距离，可自行调节 */
    private let itemLrInset: CGFloat = 30
    
    private let cellId = "item_key"
    private var scrollDirection = ScrollDirection.left
    
    var leftPadding: CGFloat = 0
    /**
     * 用于处理异步数据过来时，而此时rightCv正在translate时导致的数据错乱问题。即外部异步设置新的数据源后，不会马上reloadData，而是等到rightDisplayLink结束后才执行reloadData */
    private var isDataSourceChanged = false
    /**
     * 和上面isDataSourceChanged的作用类似，起过滤效果。是否是首次设置数据源 */
    private var isFirstSetDataSource = true
    /** 定时器是否正在运行 */
    private var isTimerRun = false
    
    /**
     * 按正常左右顺序传入即可，内部已做处理
     * 数据源没加入初始化方法是因为：有时候，可能需要在本类实例初始化后，过一段时间再赋值
     */
    var dataSource = [""] {
        
        // 无法阻止didSet的，所以用处不大
//        willSet {
//            if newValue.count == 0 || dataSource == newValue{
//                debugPrint("两次赋值 一样")
//                return
//            }
//        }
        
        didSet {
            
            if isFirstSetDataSource {
                guard dataSource.count != 0 else {
                    debugPrint("赋的是空数组")
                    return
                }
                setup()
                // 不管第一次赋值后数组遍历有没有完成，都会先显示UI
                updateSetup()
                isFirstSetDataSource = false
                
            } else {
                if oldValue == dataSource {
                    debugPrint("与上次赋的值一样")
                    return
                }
                changeDataSourceState()
            }
            
            asyncEnumerate(dataSource) { (leftPadding) in
                // cell可以超出屏幕
                asyncExecuteInMainThread(0, callback: {
                    self.leftPadding = leftPadding
                    if leftPadding == 0 {
                        self.updateSetup()
                    } else {
                        self.updateSetup(leftPadding)
                    }
                })

            }
            
        }
    }
    
    
    convenience init(with scrollDirection: ScrollDirection, frame: CGRect) {
        self.init(frame: frame)
        self.scrollDirection = scrollDirection
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeDataSourceState() {
        isDataSourceChanged = true
    }
    
    private func setup() {
        
        leftCv.frame = CGRect.init(x: 0, y: 10, width: kwidth, height: 50)
        
        let leftFrame = CGRect.init(x: kwidth, y: leftCv.y, width: kwidth, height: leftCv.height)
        let rightFrame = CGRect.init(x: -kwidth, y: leftCv.y, width: kwidth, height: leftCv.height)
        rightCv.frame = (scrollDirection == .left) ? leftFrame : rightFrame
        
        addSubview(leftCv)
        addSubview(rightCv)
        
        leftCv.delegate = self
        leftCv.dataSource = self
        rightCv.delegate = self
        rightCv.dataSource = self
        
        if #available(iOS 11.0, *) {
            leftCv.contentInsetAdjustmentBehavior = .never
            rightCv.contentInsetAdjustmentBehavior = .never
        } else {
            //            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        leftCv.register(PTTitleScrollerCell.self, forCellWithReuseIdentifier: cellId)
        rightCv.register(PTTitleScrollerCell.self, forCellWithReuseIdentifier: cellId)
    }

    private func updateSetup(_ padding: CGFloat = 0, isfromStopRightTimer: Bool = false) {
        
        // 一定要先加载所有的行，否则，因为有的行暂时没显示，故会导致scrollToItem出错
//        leftCv.reloadData()
//        rightCv.reloadData()
        
        if isFirstSetDataSource {
            
            rightCv.isHidden = false
            rightCv.reloadData()
            // 一定要先加载所有的行，否则，因为有的行暂时没显示，故会导致scrollToItem出错
            leftCv.reloadData()
            
            if scrollDirection == .left { // 3 0 1 2 3
                let lastElement = dataSource.last!
                let leftPadding = CGFloat(lastElement.count * 15) + itemLrInset * 2 + itemGap
                self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: -leftPadding, bottom: 0, right: 0)
            } else { // 3 2 1 0 3
                let lastElement = dataSource.last!
                let rightPadding = CGFloat(lastElement.count * 15) + itemLrInset * 2 + itemGap
                self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -rightPadding)
                // cell一屏显示不完时，此设置才有用
                self.leftCv.selectItem(at: IndexPath.init(row: self.dataSource.count, section: 0), animated: false, scrollPosition: .right)
                self.rightCv.selectItem(at: IndexPath.init(row: self.dataSource.count - 1, section: 0), animated: false, scrollPosition: .left)
            }
            
        } else { // 非第一次赋数据源
            
            if padding != 0 { // 说明所有的cell加一起也占不满整个屏幕
                

                leftCv.reloadData()
                
                if isTimerRun {
                    if isfromStopRightTimer {
                        stopTimer()
                        rightCv.isOpaque = false
                        
                        // 一定要先加载所有的行，否则，因为有的行暂时没显示，故会导致scrollToItem出错
//                        leftCv.reloadData()
                    } else {
                    }
                } else {
                    rightCv.isOpaque = false
                }
                
                
                // 调整UI
                if scrollDirection == .left { // 3 0 1 2 3
                    let lastElement = dataSource.last!
                    let leftPadding = CGFloat(lastElement.count * 15) + itemLrInset * 2 + itemGap
                    // contentInset.right = padding + 1,保证所有cell加一起占不满屏幕时仍可以滚动。系统默认不可滚动
                    self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: -leftPadding, bottom: 0, right: padding + 1)
                    //                self.leftCv.selectItem(at: IndexPath.init(row: 1, section: 0), animated: false, scrollPosition: .left)
                } else { // 3 2 1 0 3
                    self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: padding, bottom: 0, right: 0)
                    self.leftCv.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
                    self.rightCv.selectItem(at: IndexPath.init(row: self.dataSource.count - 1, section: 0), animated: false, scrollPosition: .left)
                }
                
                
            } else {
                rightCv.isHidden = false
                rightCv.reloadData()
                // 一定要先加载所有的行，否则，因为有的行暂时没显示，故会导致scrollToItem出错
                leftCv.reloadData()
                
                if scrollDirection == .left { // 3 0 1 2 3
                    let lastElement = dataSource.last!
                    let leftPadding = CGFloat(lastElement.count * 15) + itemLrInset * 2 + itemGap
                    self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: -leftPadding, bottom: 0, right: 0)
                } else { // 3 2 1 0 3
                    let lastElement = dataSource.last!
                    let rightPadding = CGFloat(lastElement.count * 15) + itemLrInset * 2 + itemGap
                    
                    // 当里面的cell超不出屏幕时，collectionView的contentInset和setContentOffset都不会起作用的；当cell超出屏幕时，若左边没有inset，则cv最多只会移动到让最左边的item刚好完全显示就不会再右移了，因此需要添加左边inset. 无论哪种情况，只要设置的左边的inset或offset就会起作用，右边的则不行。因为cell是从左往右加载的
                    //            self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: (100), bottom: 0, right: 0)
                    
                    self.leftCv.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: -rightPadding)
                }
                
                // cell一屏显示不完时，此设置才有用
                if self.scrollDirection == .right {
                    self.leftCv.selectItem(at: IndexPath.init(row: self.dataSource.count, section: 0), animated: false, scrollPosition: .right)
                    self.rightCv.selectItem(at: IndexPath.init(row: self.dataSource.count - 1, section: 0), animated: false, scrollPosition: .left)
                    
                }
                
                if self.isTimerRun {
                    self.isDataSourceChanged = true
                } else {
                    self.startTimer()
                }
                
            }
        }
        
        
    }

    /** 由于字体大小、屏幕大小问题，故不会遍历次数太多 */
    private func asyncEnumerate(_ ary: [String], callback: @escaping (_ result: CGFloat) -> ()) {
        var map: CGFloat = 0
        var strLength: CGFloat = 0
        asyncExecuteInSubThread(0) {
            for ele in self.dataSource.enumerated() {
                //                    debugPrint("元素为： \(ele.element, ele.offset)")
                strLength += CGFloat(ele.element.count * 15) + self.itemLrInset * 2 + self.itemGap
                // 说明数组里的字符串已经可以超出屏幕了, 只有此情况下才会添加rightCv并开启动画
                if strLength >= kwidth {
                    callback(0)
                    return
                } else {
                    if ele.offset == self.dataSource.count - 1 {
                        map = kwidth - strLength + self.itemGap
                        callback(map)
                        return
                    }
                }
            }
        }
        
    }
    
    
    private func startTimer(_ isForLeftTimer: Bool = true) {
        if isForLeftTimer {
            if leftDisplayLink == nil {
                leftDisplayLink = CADisplayLink.init(target: self, selector: #selector(handleLeftCollectionViewAnimate))
                leftDisplayLink.add(to: .main, forMode: .commonModes)
            }
        } else {
            if rightDisplayLink == nil {
                rightDisplayLink = CADisplayLink.init(target: self, selector: #selector(handleRightCollectionViewAnimate))
                rightDisplayLink.add(to: .main, forMode: .commonModes)
            }
        }
        
        isTimerRun = true
    }
    
    private func stopTimer(_ isForLeftTimer: Bool = true) {
        if isForLeftTimer {
            if leftDisplayLink == nil {
                return
            }
            leftDisplayLink.invalidate()
            leftDisplayLink = nil
        } else {
            if rightDisplayLink == nil {
                return
            }
            rightDisplayLink.invalidate()
            rightDisplayLink = nil
            
            if isDataSourceChanged {
                updateSetup(leftPadding, isfromStopRightTimer: true)
            }
            isDataSourceChanged = false
        }
        
       isTimerRun = false
    }
    
    
    @objc func handleLeftCollectionViewAnimate() {
        DispatchQueue.main.async {
            if self.scrollDirection == .left {
                let x = self.leftCv.contentOffset.x // 为正值
                self.leftCv.setContentOffset(CGPoint.init(x: x + self.mutiply, y: 0), animated: false)
            } else {
                let x = self.leftCv.contentOffset.x // 为负值
                self.leftCv.setContentOffset(CGPoint.init(x: x - self.mutiply, y: 0), animated: false)
            }
        }
        
    }
    
    @objc func handleRightCollectionViewAnimate() {
        DispatchQueue.main.async {

            if self.scrollDirection == .left {
                let transformX = self.rightCv.transform.tx
                self.rightCv.transform = CGAffineTransform.init(translationX: transformX - self.mutiply, y: 0)
                if transformX >= kwidth || transformX <= -kwidth {
                    self.stopTimer(false)
                    self.rightCv.transform = .identity
                    self.leftCv.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
                }
            } else {
                
                let transformX = self.rightCv.transform.tx
                self.rightCv.transform = CGAffineTransform.init(translationX: transformX + self.mutiply, y: 0)
                if transformX >= kwidth || transformX <= -kwidth {
                    self.stopTimer(false)
                    self.rightCv.transform = .identity
                    
                    self.leftCv.selectItem(at: IndexPath.init(row: self.dataSource.count, section: 0), animated: false, scrollPosition: .right)
                }
                
            }
            
        }
        
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

extension PTRichTitleScroller: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let index = indexPath.item
        var width: CGFloat
        
        if scrollDirection == .left {
            if collectionView == leftCv {
                if index == 0 {
                    let lastElement = dataSource.last!
                    width = CGFloat(lastElement.count * 15) + itemLrInset * 2
                } else {
                    let currentElement = dataSource[index - 1]
                    width = CGFloat(currentElement.count * 15) + itemLrInset * 2
                    
                }
            } else {
                let currentElement = dataSource[index]
                width = CGFloat(currentElement.count * 15) + itemLrInset * 2
            }
        } else {
            if collectionView == leftCv {
                if index == 0 || index == dataSource.count {
                    let lastElement = dataSource.last!
                    width = CGFloat(lastElement.count * 15) + itemLrInset * 2
                } else {
                    let currentElement = dataSource[dataSource.count - (index + 1)]
                    width = CGFloat(currentElement.count * 15) + itemLrInset * 2
                    
                }
            } else {
                let currentElement = dataSource[dataSource.count - (index + 1)]
                width = CGFloat(currentElement.count * 15) + itemLrInset * 2
            }
        }
        
        
        return CGSize.init(width: width, height: leftCv.height)
    }
    
   
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 30
    //    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == leftCv) ? dataSource.count + 1 : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemGap
    }
    
    
    // 先调
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PTTitleScrollerCell
        let index = indexPath.item
        
        // dataSource = ["0", "1", "2", "3", "4"]
        if scrollDirection == .left { // 4 0 1 2 3 4, 左边多一行
            if collectionView == leftCv {
                if index == 0 {
                    cell.titleLab.text = dataSource.last
                } else {
                    cell.titleLab.text = dataSource[index - 1]
                }
            } else {
                cell.titleLab.text = dataSource[index]
            }
        } else { // 4 3 2 1 0 4，右边多一行
            if collectionView == leftCv {
                if index == dataSource.count {
                    cell.titleLab.text = dataSource.last
                } else {
                    cell.titleLab.text = dataSource[dataSource.count - (index + 1)]
                }
            } else {
                cell.titleLab.text = dataSource[dataSource.count - (index + 1)]
            }
        }
        
        cell.tag = index
        return cell
    }
    
    
    // MARK： - 后调 cell完全展示在屏幕时
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == leftCv && scrollDirection == .right {
            if indexPath.item == 0 {
            }
        } else {
        }
        
        
    }
    
    // MARK：cell完全离开屏幕之后，就会调用didEndDisplayingCell方法
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
     // MARK：点击cell最重要的是拿到对应的模型数据
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PTTitleScrollerCell
        debugPrint("点击了第%d行，数据为：%@", indexPath.item, cell?.titleLab.text)
    }
    

    // MARK: UIScrollViewDelegate
    
    // 1. 滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        debugPrint("2222")
        let cl = scrollView as! PTTitleScrollerCollectionView
        
        if cl == leftCv {
            if scrollDirection == .left {
                
                let lastIndexPath = IndexPath.init(row: dataSource.count, section: 0)
                let lastCell = cl.cellForItem(at: lastIndexPath)
                guard lastCell != nil else {
                    return
                }
                
                // 转换坐标系
                let frame = leftCv.convert(lastCell!.frame, to: kwindow!)
                let maxPoint = CGPoint.init(x: frame.maxX, y: frame.maxY)
                let cellShowAllAtPoint = CGPoint.init(x: maxPoint.x + itemGap, y: maxPoint.y) // cell完全展示且之后又走了item间距的距离后，才开始移动rightCv
                
                if kBounds.contains(cellShowAllAtPoint) { // 最后一个cell已经完全显示
                    startTimer(false)
                }
            } else {
                let firstIndexPath = IndexPath.init(row: 0, section: 0)
                let firstCell = cl.cellForItem(at: firstIndexPath)
                guard firstCell != nil else {
                    return
                }
                
                // 转换坐标系
                let frame = leftCv.convert(firstCell!.frame, to: kwindow!)
                let minPoint = CGPoint.init(x: frame.minX, y: frame.minY)
                let cellShowAllAtPoint = CGPoint.init(x: minPoint.x - itemGap, y: minPoint.y) // cell完全展示且之后又走了item间距的距离后，才开始移动rightCv
                
                if kBounds.contains(cellShowAllAtPoint) { // 最后一个cell已经完全显示
                    startTimer(false)
                }
            }
            
        }
        
    }
    
    // MARK: 2‘ 系统自动滚动结束后: setContentOffset \ selectItem
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        debugPrint("1111")
    }
    
    
}




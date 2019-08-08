//
//  PTPopMessageViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/10/22.
//  可点击的弹幕，分行处理， 从屏幕右边缘开始，右至左运动

import UIKit
import SnapKit

class PTPopMessageViewController: UIViewController {
    
    var lastTopItemVelocity = 0.0
    var lastCenterItemVelocity = 0.0
    var lastBottomItemVelocity = 0.0
    
    // 每行可输入最大字数
    private let textLengthLimit = (kwidth + 100) / 16
    private let rowbeginY: CGFloat = 100
    private let rowVerticalPadding: CGFloat = 50
    private let rowHorizontalPadding: CGFloat = kwidth
    // 仅原来从数据组里获取单条数据
    private(set) var currentIndex = -1
    // 数据产生的时间间隔
    private let newTextCreatInterval = 1.0
    // 正常运动速度
    private let velocity = 100.0
    private var positionLabels = [PTTapLabel]()
    
    private let topContainer = PTPopMessageContainerView()
    private let centerContainer = PTPopMessageContainerView()
    private let bottomContainer = PTPopMessageContainerView()
    
    private var animateLayers = [CALayer]()
    private var timer: Timer!
    private var cacheMsgLab: PTPopMessageLabel!
    let firstTexts = ["aaaaaaaaaaaaaaa---------a数据产生的时间间隔", "bbbbbbbb---------====================", "常运动速度常运动速度常运动速度常运动速度常运动速度常运动速度常运动速度c-cc", "dddddddddddddddddd", "e", "fffff", "ggggg", "hh", "iiiiiiii"]
    
    private let showClickLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightText
        setupPopMessageContaner()
        setupAnimateControlButton()
        setup()
        setupTimer()
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: newTextCreatInterval, repeats: true, block: {[weak self] (_) in
            guard let `self` = self else {
                return
            }
            self.timerAction()
        })
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    private func setup() {
        view.addSubview(showClickLabel)
        showClickLabel.numberOfLines = 0
        showClickLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-140)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
    
    private func setupPopMessageContaner() {
        view.addSubview(topContainer)
        view.addSubview(centerContainer)
        view.addSubview(bottomContainer)
        topContainer.backgroundColor = .gray
        centerContainer.backgroundColor = .cyan
        bottomContainer.backgroundColor = .brown
        
        topContainer.snp.makeConstraints { (make) in
            make.top.equalTo(rowbeginY)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        centerContainer.snp.makeConstraints { (make) in
            make.top.equalTo(topContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        bottomContainer.snp.makeConstraints { (make) in
            make.top.equalTo(centerContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func setupAnimateControlButton() {
        let pauseBtn = PTTapLabel(with: .gray, fontSize: 20)
        pauseBtn.text = "暂停"
        let continueBtn = PTTapLabel(with: .gray, fontSize: 20)
        continueBtn.text = "继续"
        
        view.addSubview(pauseBtn)
        view.addSubview(continueBtn)
        pauseBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-80)
            make.left.equalTo(30)
        }
        continueBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(pauseBtn)
            make.right.equalTo(-30)
        }
        
        // 暂停隐式动画与继续隐式动画
        pauseBtn.tapClosure = {[unowned self]_,_ in
            let bcLayer = self.bottomContainer.layer
            let pausedTime = bcLayer.convertTime(CACurrentMediaTime(), from: nil)
            bcLayer.speed = 0.0
            bcLayer.timeOffset = pausedTime
        }
        continueBtn.tapClosure = {[unowned self]_,_ in
            let bcLayer = self.bottomContainer.layer
            let pausedTime = bcLayer.timeOffset
            bcLayer.speed = 1.0
            // 必须得要此句
            bcLayer.beginTime = 0.0
            let timeSincePause = bcLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            bcLayer.beginTime = timeSincePause
        }
    }
    
    @objc private func timerAction() {
        doPopMessageAction()
    }
    
    private func doPopMessageAction() {
        currentIndex += 1
        
        let contentItem = PTPopMessageLabel(with: .black, fontSize: 16)
        
        // 求出item需要出现的位置
        let result = getRowAndLastItemMaxXWhenShowCurrentItem()
        let row = result.0
        // 当前item应该添加到的行号
        let rowContainer = self.getContainerInRow(row)
        
        contentItem.textAlignment = .left
        contentItem.text = self.firstTexts[self.currentIndex % self.firstTexts.count]
        // 先不加item加到container上，而是加到一个无用的view上，只要之后能获取frame即可，之后再加到container上
        self.view.addSubview(contentItem)
        
        // 记录tag
        contentItem.tag = self.currentIndex
        contentItem.tapClosure = {[unowned self]label in
            self.tapAction(text: label.text!, label: label)
        }
        
        contentItem.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.right)
            make.centerY.equalToSuperview()
        }
        
        delay(0.05) { // [weak self] in
//            guard let `self` = self else {
//                return
//            }
           
            // 调整item的间距
            let result = self.getRowAndLastItemMaxXWhenShowCurrentItem()
            let lastItemMaxX = result.1
            let velocity = self.getVelocityForCurrentItem(contentItem, in: row, lastItemMaxX: lastItemMaxX)
            
            // 将currentItem加入rowContainer上面
            rowContainer.addSubview(contentItem)
            
            // 与上一个item的间隔 lastItemMaxX
            var currentItemLeftToScreenRightPadding: CGFloat = 0
            if lastItemMaxX > 100 && contentItem.width > 100 { // item间距 ==rowHorizontalPadding+100
                currentItemLeftToScreenRightPadding = (lastItemMaxX + self.rowHorizontalPadding) - kwidth + 100
            } else { // item间距 ==rowHorizontalPadding
                if lastItemMaxX == 0 {
                    currentItemLeftToScreenRightPadding =  0
                } else {
                    currentItemLeftToScreenRightPadding = (lastItemMaxX + self.rowHorizontalPadding) - kwidth
                }
            }
            
            // 更新当前item需要走的总距离
            // 需要走的距离
            let currentItemAnimateTotalDistance = kwidth + contentItem.width +  currentItemLeftToScreenRightPadding
            contentItem.snp.removeConstraints()
            contentItem.snp.remakeConstraints{ (make) in make.left.equalTo(rowContainer.snp.right).offset(currentItemLeftToScreenRightPadding)
                make.centerY.equalToSuperview()
            }
            
            let currentItemAnimateTime = Double(currentItemAnimateTotalDistance) / velocity
            
            UIView.animate(withDuration: currentItemAnimateTime, delay: 0, options: .curveLinear, animations: {
                contentItem.transform = CGAffineTransform.init(translationX: -currentItemAnimateTotalDistance, y: 0)
            }) {(finished) in
                if finished {
                    contentItem.snp.removeConstraints()
                    contentItem.removeFromSuperview()
                    contentItem.transform = .identity
                }
            }
        }
        
    }
    
    
    /// 获取当前item应该有的速度, 为了防止出现a加速了他之后的b也加速了之后的d也加速了且都在同一行，则需要做一些处理
    func getVelocityForCurrentItem(_ currentItem: UILabel, in row: Int, lastItemMaxX: CGFloat) -> Double {
        
        var velocity = 0.0
        
        var currentItemLeftToScreenRightPadding: CGFloat = 0
        // 调整item的间距
        if lastItemMaxX > 100 && currentItem.width > 100 { // item间距 ==rowHorizontalPadding+100
            currentItemLeftToScreenRightPadding = (lastItemMaxX + self.rowHorizontalPadding) - kwidth + 100
        } else { // item间距 ==rowHorizontalPadding
            if lastItemMaxX == 0 {
                currentItemLeftToScreenRightPadding = 0
            } else {
                currentItemLeftToScreenRightPadding = (lastItemMaxX + self.rowHorizontalPadding) - kwidth
            }
        }
        
        let lastItemVelocitys = [self.lastTopItemVelocity, self.lastCenterItemVelocity, self.lastBottomItemVelocity]
        let lastItemVelocity = lastItemVelocitys[row]
        
//        if currentItem.text!.contains("dd") {
//            PTPrint("上一次的信息 \(row)")
//        }
        
        if lastItemVelocity == 0 || lastItemMaxX == 0 {
            velocity = self.velocity
        } else {
            // 只有当上一个item的maxX超出屏幕右边时才使当前item增速
            if lastItemMaxX > 100 && currentItem.width > 100 {
                if lastItemVelocity > self.velocity {
                    velocity = self.velocity
                } else {
                    // 上一个item完全消失还需要的时间
                    let theLastItemInSameRowSurplusAnimateTime = Double(lastItemMaxX) / lastItemVelocity
                    // 运动至屏幕左对齐所需的距离
                    let currentItemAnimateDistance = kwidth + currentItemLeftToScreenRightPadding - 20
                    velocity = Double(currentItemAnimateDistance) / theLastItemInSameRowSurplusAnimateTime
                }
            } else {
                velocity = self.velocity
            }
        }

        if row == 0 {
            self.lastTopItemVelocity = velocity
        } else if row == 1 {
            self.lastCenterItemVelocity = velocity
        } else if row == 2 {
            self.lastBottomItemVelocity = velocity
        }

        return velocity
    }
    
    /// 获取行号、和上一个item的maxX, 即当前item应该在哪出现
//    private func getRowAndLastItemMaxXWhenShowCurrentItem(closure: @escaping ((Int, CGFloat) -> ())) {
//
//        if topContainer.subviews.count == 0 {
//            closure(0, 0)
//        } else if centerContainer.subviews.count == 0 {
//            closure(1, 0)
//        } else if bottomContainer.subviews.count == 0 {
//            closure(2, 0)
//        } else {
//            let topItemMaxX = getMaxXForView(topContainer.subviews.last!)
//            let centerItemMaxX = getMaxXForView(centerContainer.subviews.last!)
//            let bottomItemMaxX = getMaxXForView(bottomContainer.subviews.last!)
//            let itemMaxXs = [topItemMaxX, centerItemMaxX, bottomItemMaxX]
//
//            // kvo快速求数组的和、最值, 立马得结果无须异步回调
//            let minX = (itemMaxXs as! NSArray).value(forKeyPath: "@min.doubleValue")! as! CGFloat
//            let row = itemMaxXs.index(of: minX)!
//             closure(row, minX)
//
//            // 冒泡遍历数组求最小值
////            var minX: CGFloat = 0
////            var row = 1
////            let limit = itemMaxXs.count
////            for i in 0..<limit-1 {
////                for j in 0..<limit-1-i {
////                    var leftItemMaxX = itemMaxXs[j]
////                    let rightItemMaxX = itemMaxXs[j+1]
////                    if leftItemMaxX > rightItemMaxX {
////                        leftItemMaxX = rightItemMaxX
////                    }
////                    if i == limit - 2 && j == limit - 1 - i - 1 {
////                        row = itemMaxXs.index(of: leftItemMaxX)!
////                        minX = leftItemMaxX
////                        closure(row, minX)
////                    }
////                }
////            }
//        }
//
//    }
    
    /// 获取行号、和上一个item的maxX, 即当前item应该在哪出现
    private func getRowAndLastItemMaxXWhenShowCurrentItem() -> (Int, CGFloat) {
        
        if topContainer.subviews.count == 0 {
            return (0, 0)
        } else if centerContainer.subviews.count == 0 {
            return (1, 0)
        } else if bottomContainer.subviews.count == 0 {
            return (2, 0)
        } else {
            let topItemMaxX = getMaxXForView(topContainer.subviews.last!)
            let centerItemMaxX = getMaxXForView(centerContainer.subviews.last!)
            let bottomItemMaxX = getMaxXForView(bottomContainer.subviews.last!)
            let itemMaxXs = [topItemMaxX, centerItemMaxX, bottomItemMaxX]
            // kvo快速求数组的和、最值, 立马得结果无须异步回调
            let minX = (itemMaxXs as NSArray).value(forKeyPath: "@min.doubleValue")! as! CGFloat
            let row = itemMaxXs.index(of: minX)!
            return(row, minX)
        }
        
    }

    private func tapAction(text: String, label: PTBaseLabel) {
        PTPrint("点击了第\(label.tag)个数据")
        showClickLabel.text = text
    }
    
    /// 获取当前正在进行动画的item此刻的最大maxX(时刻变化的)
    private func getMaxXForView(_ view: UIView) -> CGFloat {
        // 隐式动画过程中view的frame一开始就是动画结束时的值了，故不能去frame；而应取presentation的frame，动画时才有此frame且随动画而改变
        if let visiableLayer = view.layer.presentation() {
            return visiableLayer.frame.maxX
        } else {
            return view.frame.maxX
        }
    }
    
    /// 获取当前行的容器
    private func getContainerInRow(_ row: Int) -> UIView {
        if view.subviews.count == 0 {
            return UIView()
        }
        return view.subviews[row]
    }
    
    deinit {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        positionLabels.removeAll()
        currentIndex = -1
    }
}

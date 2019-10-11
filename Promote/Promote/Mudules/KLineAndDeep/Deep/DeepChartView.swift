//
//  DeepChartView.swift
//  TestWlNormal
//
//  Created by Bava on 2019/10/11.
//  Copyright © 2019 Bava. All rights reserved.
//  股票 比特币 深度图     layer 沿着路径path移动

import UIKit


// 折线上面的点
fileprivate var deepChartViewBrokeLinePoints = [CGPoint]()


/// swift 使用@convention(c) 【即支持c语言的闭包时的情况】
//@convention(swift) : 表明这个是一个swift的闭包
//@convention(block) ：表明这个是一个兼容oc的block的闭包
//@convention(c) : 表明这个是兼容c的函数指针的闭包。
fileprivate let getPathPointsInDeepChartView: @convention(c) (UnsafeMutableRawPointer?, UnsafePointer<CGPathElement>) -> Void = {_, element in
    let point = element.pointee.points.pointee
    let type = element.pointee.type
    if type != .closeSubpath {
        if type != .addLineToPoint && type != .moveToPoint {
            
        }
    }
    let bufferPointer = UnsafeBufferPointer.init(start: element.pointee.points, count: 1)
    let result = bufferPointer.shuffled()
    // brokePoints 必须为一个全局量，即不能在类里
    deepChartViewBrokeLinePoints += result
}



class PTDeepChartView: UIView {

    // 买盘价格
    let buyPrices = [5.4, 4.2, 3.1, 2, 1.2]
    // 卖盘
    let sellPrices = [6.1, 6.8, 7.1, 7.9, 8.8]
    
    let currentPrice = 5.8
    // 买盘价格对应的买盘数量
    let buyCounts = [90.0, 150.12, 100.77, 300, 100]
    let sellCounts = [100, 50.45, 200.12, 40.22, 53.12]
    
    
    private let container = UIView()
    private let contentView = UIView()
    private var contentViewW: CGFloat = 0.0
    private var contentViewH: CGFloat = 0.0
    
    private var amtLabs = [UILabel]()
    private let tapLayer = CALayer()
    
    // -------
    // 深度有几档
    let totalDeepPart = 7
    private var buyDeepCounts = [Double]()
    private var sellDeepCounts = [Double]()
    // 坐标系里的坐标值
    private var buyPoints = [CGPoint]()
    private var sellPoints = [CGPoint]()
    
    // 折线path
    private var brokeLinePath = UIBezierPath()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if buyPoints.count == 0 {
            drawAllLayer()
        }
    }
    
    /// 绘制，外部调用，为了使frame正确
    func drawAllLayer() {
        contentViewW = contentView.frame.width
        contentViewH = contentView.frame.height
        //        drawBottomLayer()
        drawSepLayer()
        drawRightLayerAndCaculatePoints()
        addTapLayer()
    }
    
    private func setup() {
        let topView = UIView()
        
        addSubview(container)
        container.addSubview(contentView)
        container.addSubview(topView)
        
        contentView.backgroundColor = .gray
        topView.backgroundColor = .lightGray
        
        let buyPView = UIView()
        let sellPView = UIView()
        let pview = UIView()
        
        let buyIcon = UIView()
        let buyLab = UILabel()
        let sellIcon = UIView()
        let sellLab = UILabel()
        
        topView.addSubview(pview)
        pview.addSubview(buyPView)
        pview.addSubview(sellPView)
        buyPView.addSubview(buyIcon)
        buyPView.addSubview(buyLab)
        sellPView.addSubview(sellIcon)
        sellPView.addSubview(sellLab)
        
        buyIcon.backgroundColor = .red
        sellIcon.backgroundColor = .green
        
        buyIcon.layer.cornerRadius = 6
        sellIcon.layer.cornerRadius = 6
        
        buyLab.text = "Buying"
        sellLab.text = "Selling"
        
        //        buyPView.backgroundColor = .red
        //        sellPView.backgroundColor = .green
        
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentView.snp_top)
            make.height.equalTo(44)
        }
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        // 控制买卖文字的间距 144时为0,
        pview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(12)
        }
        buyPView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(sellPView.snp_left)
        }
        buyIcon.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        buyLab.snp.makeConstraints { (make) in
            make.left.equalTo(buyIcon.snp_right).offset(5)
            make.centerY.equalToSuperview()
        }
        sellPView.snp.makeConstraints { (make) in
            make.width.equalTo(buyPView)
            make.right.top.bottom.equalToSuperview()
        }
        sellIcon.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(12)
        }
        sellLab.snp.makeConstraints { (make) in
            make.left.equalTo(sellIcon.snp_right).offset(5)
            make.centerY.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        contentView.addGestureRecognizer(tap)
        
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        
        tapLayer.isHidden = false
        
        
        var tapPoint = tap.location(in: contentView)
        
        if #available(iOS 11.0, *) {
            if deepChartViewBrokeLinePoints.count == 0 {
                // 获取路径path上所有的点
                brokeLinePath.cgPath.applyWithBlock { (element) in
                    let point = element.pointee.points.pointee
                    let type = element.pointee.type
                    if type != .closeSubpath {
                        if type != .addLineToPoint && type != .moveToPoint {
                            
                        }
                    }
                    deepChartViewBrokeLinePoints.append(point)
                    print("ios11 获取到的路")
                }
            }
        } else {
            // 获取路径path上所有的点
            // 1.1
//            if deepChartViewBrokePoints.count == 0 {
//                brokeLinePath.cgPath.apply(info: nil) { (nil, element) in
//                    let point = element.pointee.points.pointee
//                    let type = element.pointee.type
//                    if type != .closeSubpath {
//                        if type != .addLineToPoint && type != .moveToPoint {
//
//                        }
//                    }
//                    let bufferPointer = UnsafeBufferPointer.init(start: element.pointee.points, count: 1)
//                    let result = bufferPointer.shuffled()
//                    deepChartViewBrokePoints += result
//                }
//            }
            
            // 1.2
            if deepChartViewBrokeLinePoints.count == 0 {
                brokeLinePath.cgPath.apply(info: nil, function: getPathPointsInDeepChartView)
            }
        }
        
        // 价格
        let maxBuyPrice = CGFloat(buyPrices.max()!)
        let minBuyPrice = CGFloat(buyPrices.min()!)
        // 当前成交价-最小买盘价
        let buyPricePadding = CGFloat(currentPrice) - minBuyPrice
        
        
        let maxSellPrice = CGFloat(sellPrices.max()!)
        let minSellPrice = CGFloat(sellPrices.min()!)
        // 最大卖盘价 - 当前成交价
        let sellPricePadding = CGFloat(currentPrice) - minSellPrice
        
        // 深度
        let maxBuyCount = buyDeepCounts.max()!
        let maxSellCount = sellDeepCounts.max()!
        let maxDeepCount = max(maxBuyCount, maxSellCount)
        // 每个高度点代表的深度值
        let deedPadding = CGFloat(maxDeepCount) / contentViewH
        
        let tapX = tapPoint.x
        let tapY = tapPoint.y
        // 点击点的深度值
        let tapYValue = (contentViewH - tapY) * deedPadding
        var tapXValue: CGFloat = 0.0
        // 分点击点在买还是卖盘
        if tapX <= contentViewH / 2 { // 买盘
            tapXValue = (tapX / (contentViewW / 2)) * buyPricePadding + minBuyPrice
        } else {
            tapXValue = ((tapX - contentViewW / 2) / (contentViewW / 2)) * sellPricePadding + minSellPrice
        }
        
        
        print("坐标为: \(tapPoint);  价格 \(tapXValue)--- 深度\(tapYValue)")
        
        // 点击的点与路径各个点的间距
        var pointPaddings = [CGFloat]()
        for point in deepChartViewBrokeLinePoints {
            let padding = abs(point.x - tapPoint.x)
            pointPaddings.append(padding)
        }
        // 点击时改变指示layer位置至点击点
        let minTmp = pointPaddings.min() ?? 0
        if let index = pointPaddings.firstIndex(of: minTmp) {
            let currentPathPoint = deepChartViewBrokeLinePoints[index]
            tapLayer.position = currentPathPoint
        }
        
        // 3. layer 沿着路径path移动
//        let keyFrameAnimate = CAKeyframeAnimation(keyPath: "position")
//        keyFrameAnimate.path = brokeLinePath.cgPath
//        keyFrameAnimate.duration = 0
//        tapLayer.add(keyFrameAnimate, forKey: nil)
        
    }
    
}




/// 绘制
extension PTDeepChartView {
    
    private func drawBottomLayer() {
        
        let totalHCount = buyPrices.count + sellPrices.count
        let mutiW = contentViewW / CGFloat(totalHCount - 1)
        
        for i in 0..<totalHCount {
            var buyPrice = 0.0
            var sellPrice = 0.0
            
            let priceLayer = CATextLayer()
            priceLayer.fontSize = 15
            
            if i < (totalHCount - 1) / 2 {
                buyPrice = buyPrices[i]
                priceLayer.string = "\(buyPrice)"
                priceLayer.foregroundColor = UIColor.green.cgColor
            } else if i == (totalHCount - 1) / 2 {
                buyPrice = buyPrices[i]
                priceLayer.string = "\(buyPrice)"
                priceLayer.foregroundColor = UIColor.white.cgColor
            } else {
                sellPrice = sellPrices[i - (totalHCount + 1) / 2]
                priceLayer.string = "\(sellPrice)"
                priceLayer.foregroundColor = UIColor.red.cgColor
            }
            
            let x = CGFloat(i) * mutiW
            let y = contentView.frame.height - 20
            priceLayer.frame = CGRect(x: x, y: y, width: 30, height: 15)
            contentView.layer.addSublayer(priceLayer)
        }
        
        
        let layer = CALayer()
        let y = contentView.frame.height - 21
        layer.frame = CGRect(x: 0, y: y, width: contentViewW, height: 0.5)
        layer.backgroundColor = UIColor.blue.cgColor
        contentView.layer.addSublayer(layer)
        
    }
    
    /// 计算坐标
    private func drawRightLayerAndCaculatePoints() {
        
        // 买卖盘的价格或数量都不为空才处理
        guard buyPrices.count != 0 && sellPrices.count != 0 && buyCounts.count != 0 && sellCounts.count != 0 else {
            return
        }
        
        // 计算深度值
        for i in 0..<buyCounts.count {
            var currentDeepCount = 0.0
            for j in 0...i {
                let buyCount = buyCounts[j]
                currentDeepCount += buyCount
            }
            buyDeepCounts.append(currentDeepCount)
        }
        
        for i in 0..<sellCounts.count {
            var currentDeepCount = 0.0
            for j in 0...i {
                let sellCount = sellCounts[j]
                currentDeepCount += sellCount
            }
            sellDeepCounts.append(currentDeepCount)
        }
        
        
        // 计算交易对应的坐标
        let maxBuyDeepCount = buyDeepCounts.last!
        let minBuyDeepCount = buyDeepCounts.first!
        
        let maxSellDeepCount = sellDeepCounts.last!
        let minSellDeepCount = sellDeepCounts.first!
        
        // 最大深度
        let maxDeepCount = max(maxBuyDeepCount, maxSellDeepCount)
        let minDeepCount = max(minBuyDeepCount, minSellDeepCount)
        
        // 若纵轴从最小深度绘倒最大深度，即纵坐标最小为0；即他代表的深度值从最小深度-->最大深度
//        let deepPadding = CGFloat(maxDeepCount - minDeepCount) / contentViewH
        // 纵坐标即他代表的深度值从0-->最大深度
        let deepPadding = CGFloat(maxDeepCount) / contentViewH
        
        
        // 竖直成交量
        
        //        let reverseBuyDeepCounts = buyDeepCounts.enumerated().reversed()
        for i in 0..<totalDeepPart {
            let yDeepCount =  maxDeepCount / Double(totalDeepPart - 1)
            let yDeepCountStr = String(format: "%.2f", yDeepCount * Double(i))
            amtLabs[totalDeepPart - 1 - i].text = yDeepCountStr
        }
        
        
        // --------- 买盘  在图的左半部分 ------------
        
        // x轴 每一点的买盘价格
        let maxBuyPrice = buyPrices.first!
        let minBuyPrice = buyPrices.last!
        
        // 买盘的最大差价, 当前成交价 - 最小买盘价
        let buyPricePadding = currentPrice - minBuyPrice // maxBuyPrice - minBuyPrice
        // 每个点代表多少价格 价格间距
        let xBuyPricePart = CGFloat(maxBuyPrice - minBuyPrice) / (contentViewW / 2)
        
        
        
        // 买盘坐标
        var xBuyPoints = [CGFloat]()
        var yBuyPoints = [CGFloat]()
        
        // x
        for i in 0..<buyPrices.count {
            let buyPrice = buyPrices[i]
            let price = abs(buyPrice - minBuyPrice) / buyPricePadding
            let x = CGFloat(price) * (contentViewW / 2)
            xBuyPoints.append(x)
        }
        // y  注意深度值 buyDeepCount - minBuyDeepCount 或 buyDeepCount - 0
        for i in 0..<buyDeepCounts.count {
            let buyDeepCount = buyDeepCounts[i]
            let deep = CGFloat(buyDeepCount) / deepPadding // CGFloat(buyDeepCount - minBuyDeepCount) / deepPadding
            let y = deep
            yBuyPoints.append(y)
        }
        
        // 最终坐标
        xBuyPoints.sort { // 升序
            return $0 <= $1
        }
        yBuyPoints.sort { // 降序
            return $0 >= $1
        }
        // 计算买盘坐标
        for i in 0..<xBuyPoints.count {
            let x = xBuyPoints[i]
            let y = contentViewH - yBuyPoints[i]
            let point = CGPoint(x: x, y: y)
            buyPoints.append(point)
        }
        
        // --------- 卖盘  ------------
        
        // x轴 每一点的卖盘价格
        var xSellPoints = [CGFloat]()
        var ySellPoints = [CGFloat]()
        
        let maxSellPrice = sellPrices.last!
        let minSellPrice = sellPrices.first!
        
        // 卖盘的最大差价, 最大卖盘价 - 当前成交价
        let sellPricePadding = maxSellPrice - currentPrice  // maxSellPrice - minSellPrice
        // 每个点代表多少价格 价格间距
        let xSellPricePart = CGFloat(sellPricePadding) / (contentViewW / 2)
        
        
        
        // 卖盘坐标 在图的右半部分
        // x
        for i in 0..<sellPrices.count {
            let sellPrice = sellPrices[i]
            let price = abs(sellPrice - minSellPrice) / sellPricePadding
            let x = CGFloat(price) * (contentViewW / 2) + contentViewW / 2
            xSellPoints.append(x)
        }
        // y
        for i in 0..<sellDeepCounts.count {
            let sellDeepCount = sellDeepCounts[i]
            let deep = contentViewH - (CGFloat(sellDeepCount) / deepPadding)
            let y = deep
            ySellPoints.append(y)
        }
        
        // 最终坐标
        xSellPoints.sort { // 升序
            return $0 <= $1
        }
        ySellPoints.sort { // 降序
            return $0 >= $1
        }
        // 计算卖盘坐标
        for i in 0..<xSellPoints.count {
            let x = xSellPoints[i]
            let y = ySellPoints[i]
            let point = CGPoint(x: x, y: y)
            sellPoints.append(point)
        }
        
        // 划走势线
        //            let path = CGMutablePath()
        let buyPath = UIBezierPath()
        let sellPath = UIBezierPath()
        
        let buyShapeLayer = CAShapeLayer()
        let sellShapeLayer = CAShapeLayer()
        
        buyShapeLayer.fillColor = UIColor.green.cgColor
        //        buyShapeLayer.strokeColor = UIColor.gray.cgColor
        //        buyShapeLayer.borderWidth = 1
        sellShapeLayer.fillColor = UIColor.red.cgColor
        
        contentView.layer.addSublayer(buyShapeLayer)
        contentView.layer.addSublayer(sellShapeLayer)
        
        
        
        // 买盘趋势线 leftTopPoint防止卖盘最后一个点离最左边还有间距
        let leftTopPoint = CGPoint(x: 0, y: buyPoints.first!.y)
        let leftBottmPoint = CGPoint(x: 0, y: contentViewH)
        let buyCenterPoint = CGPoint(x: contentViewW / 2, y: contentViewH)
        let lastBuyPoint = buyPoints.last!
        
        for i in 0..<buyPoints.count {
            let point = buyPoints[i]
            if i == 0 {
                buyPath.move(to: lastBuyPoint)
                buyPath.addLine(to: buyCenterPoint)
                buyPath.addLine(to: leftBottmPoint)
                buyPath.addLine(to: leftTopPoint)
                buyPath.addLine(to: point)
            } else {
                buyPath.addLine(to: point)
            }
        }
        
        buyShapeLayer.path = buyPath.cgPath
        
        // 卖盘趋势线  rightTopPoint防止卖盘最后一个点离最右边还有间距
        let rightTopPoint = CGPoint(x: contentViewW, y: sellPoints.last!.y)
        let rightBottmPoint = CGPoint(x: contentViewW, y: contentViewH)
        let sellCenterPoint = buyCenterPoint
        let lastSellPoint = sellPoints.last!
        
        for i in 0..<sellPoints.count {
            let point = sellPoints[i]
            if i == 0 {
                sellPath.move(to: lastSellPoint)
                sellPath.move(to: rightTopPoint)
                sellPath.addLine(to: rightBottmPoint)
                sellPath.addLine(to: sellCenterPoint)
                sellPath.addLine(to: point)
            } else {
                sellPath.addLine(to: point)
            }
        }
        
        sellShapeLayer.path = sellPath.cgPath
        
        
        // 手指折线路径
        var brokeLinePoints = buyPoints + sellPoints
        for i in 0..<brokeLinePoints.count {
            let point = brokeLinePoints[i]
            if i == 0 {
                brokeLinePath.move(to: point)
            } else {
                brokeLinePath.addLine(to: point)
            }
        }
        
    }
    
    /// 分割线
    private func drawSepLayer() {
        for i in 0..<totalDeepPart {
            let hLayer = UILabel()
            hLayer.backgroundColor = .orange
            let fi = CGFloat(i)
            let y = contentView.frame.height / CGFloat(totalDeepPart - 1) * fi
            hLayer.frame = CGRect(x: 0, y: y, width: contentView.frame.width, height: 1)
            contentView.addSubview(hLayer)
            
            
            let amtLab = UILabel()
            amtLab.textColor = .white
            amtLab.textAlignment = .right
            container.addSubview(amtLab)
            amtLab.snp.makeConstraints { (make) in
                make.right.equalTo(contentView)
                make.bottom.equalTo(hLayer.snp_top).offset(1)
            }
            contentView.bringSubviewToFront(amtLab)
            amtLabs.append(amtLab)
        }
        
        
        for i in 0...5 {
            let vLayer = UILabel()
            vLayer.backgroundColor = .orange
            let fi = CGFloat(i)
            let x = contentView.frame.width / 5 * fi
            vLayer.frame = CGRect(x: x, y: 0, width: 1, height: contentView.frame.height)
            contentView.addSubview(vLayer)
        }
        
    }
    
    /// 大家时的layer
    private func addTapLayer() {
        contentView.layer.addSublayer(tapLayer)
        tapLayer.backgroundColor = UIColor.orange.cgColor
        tapLayer.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        tapLayer.cornerRadius = tapLayer.frame.width / 2
        tapLayer.isHidden = true
    }
    
}

//
//  ChartViewController.swift
//  TestWlNormal
//
//  Created by Bava on 2019/9/23.
//  Copyright © 2019 Bava. All rights reserved.
//  股票 k线图

import UIKit

class PTKLineViewController: UIViewController {

    let cellId = "chartCell_id"
    var pinScale = 1.0
    var itemW = 100.0
    let itemH = 300.0
    var lastItemW = 100.0
    
    var chartModels = [PTKLineModel]()
    
    let maxPriceLab = UILabel()
    
    
    var visibleIndexs = [Int]()
    var visibleCellMaxPrices = [Double]()
    
    
    
    
    lazy var layout: UICollectionViewFlowLayout = {
        let ly = UICollectionViewFlowLayout()
        ly.itemSize = CGSize(width: itemW, height: itemH)
        ly.minimumLineSpacing = 10
        ly.scrollDirection = .horizontal
        ly.minimumInteritemSpacing = 0
        return ly
    }()
    
    lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRect(x: 0, y: 100, width: kwidth, height: CGFloat(itemH)), collectionViewLayout: layout)
        clv.backgroundColor = .gray
        clv.dataSource = self
        clv.delegate = self
        clv.register(PTKLineCell.self, forCellWithReuseIdentifier: cellId)
        return clv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        chartModels = getModelArrayFromFile("1dayData")
        
        view.addSubview(collectionView)
        let pin = UIPinchGestureRecognizer(target: self, action: #selector(pinAction(_:)))
        collectionView.addGestureRecognizer(pin)
        collectionView.reloadData()
        
        ////
        // 主动触发一次滚动
        collectionView.setContentOffset(CGPoint(x: 10, y: 0), animated: false)
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        
        view.addSubview(maxPriceLab)
        maxPriceLab.text = "此时最大值："
        maxPriceLab.font = UIFont.systemFont(ofSize: 20)
        maxPriceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-80)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func pinAction(_ pin: UIPinchGestureRecognizer) {
        
        // 缩放cell
//        if pinScale > 2 || pinScale < 0.5 {
//            return
//        }
        
//        if pin.state == .began || pin.state == .changed {
//            pinScale = Double(pin.scale)
//            collectionView.reloadData()
//            pin.scale = 1
//            pinScale *= Double(pin.scale)
//            print("缩放手势的比例： \(pinScale)")
//
//        }
        
        
        // 缩放布局，主要是宽度
        if pin.state == .began || pin.state == .changed {
            
            if lastItemW > 150 {
                lastItemW = 150
            } else if lastItemW < 20 {
                lastItemW = 20
            }
            
            pinScale = Double(pin.scale)
//            collectionView.reloadData()
            let newItemW = lastItemW * pinScale
            layout.itemSize = CGSize(width: newItemW, height: itemH)
            
            
            pin.scale = 1
            pinScale *= Double(pin.scale)
            print("缩放手势的比例： \(pinScale)")
            lastItemW = newItemW
            
        }
        
    }

    

     // ---------------- private
    
    // MARK: - Method
    func getModelArrayFromFile(_ fileName: String) -> [PTKLineModel] {
        let pathForResource = Bundle.main.path(forResource: fileName, ofType: "json")
        let json = try! String(contentsOfFile: pathForResource!, encoding: String.Encoding.utf8)
        let jsonData = json.data(using: String.Encoding.utf8)!
        
        let dict = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : Any]
        
        let klines = (dict["data"] as! [String : Any])["klines"] as! [[String : Any]]
        
        var models = [PTKLineModel]()
        for klineDict in klines {
            let model = PTKLineModel()
            if let open = klineDict["open"] as? Double {
                model.open = open
            }
            if let close = klineDict["close"] as? Double {
                model.close = close
            }
            if let high = klineDict["high"] as? Double {
                model.high = high
            }
            if let low = klineDict["low"] as? Double {
                model.low = low
            }
            if let volumefrom = klineDict["volumefrom"] as? Double {
                model.volumefrom = volumefrom
            }
            if let time = klineDict["time"] as? TimeInterval {
                model.time = time
            }
            if let inflow = klineDict["inflow"] as? Double {
                model.inflow = inflow
            }
            if let outflow = klineDict["outflow"] as? Double {
                model.outflow = outflow
            }
            if let boll_mb = klineDict["boll_mb"] as? Double {
                model.boll_mb = boll_mb
            }
            if let boll_up = klineDict["boll_up"] as? Double {
                model.boll_up = boll_up
            }
            if let boll_dn = klineDict["boll_dn"] as? Double {
                model.boll_dn = boll_dn
            }
            if let ma5 = klineDict["ma5"] as? Double {
                model.ma5 = ma5
            }
            if let ma10 = klineDict["ma10"] as? Double {
                model.ma10 = ma10
            }
            if let ma30 = klineDict["ma30"] as? Double {
                model.ma30 = ma30
            }
            if let ma60 = klineDict["ma30"] as? Double {
                model.ma60 = ma60
            }
            if let macd_diff = klineDict["macd_diff"] as? Double {
                model.macd_diff = macd_diff
            }
            if let macd_dea = klineDict["macd_dea"] as? Double {
                model.macd_dea = macd_dea
            }
            if let macd_bar = klineDict["macd_bar"] as? Double {
                model.macd_bar = macd_bar
            }
            if let boll_dn = klineDict["boll_dn"] as? Double {
                model.boll_dn = boll_dn
            }
            if let kdj_k = klineDict["kdj_k"] as? Double {
                model.kdj_k = kdj_k
            }
            if let kdj_d = klineDict["kdj_d"] as? Double {
                model.kdj_d = kdj_d
            }
            if let kdj_j = klineDict["kdj_j"] as? Double {
                model.kdj_j = kdj_j
            }
            if let rsi = klineDict["rsi"] as? Double {
                model.rsi = rsi
            }
            models.append(model)
        }
        return models
    }
    
    
}

extension PTKLineViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PTKLineCell
//        cell.text = "\(indexPath.row)"
//        cell.labSizeScale = pinScale
        cell.tag = row
        cell.setModel(chartModels[row])
        return cell
    }
    
    
    
    func updateVisibleData() {
        // 获取的显示的cell，即可见的
        let chartCells = collectionView.visibleCells
        
        visibleIndexs.removeAll()
        visibleCellMaxPrices.removeAll()
        
        for i in 0..<chartCells.count {
            let cell = chartCells[i] as! PTKLineCell
            let tag = cell.tag
            visibleIndexs.append(tag)
            
            let maxPrice = chartModels[tag].high
            visibleCellMaxPrices.append(maxPrice)
        }
        
        if visibleIndexs.count == 0 {
            return
        }
        let maxIndex = visibleIndexs.max()!
        if maxIndex < chartModels.count {
            let rightIndex = maxIndex + 1
//            print("最大index: \(rightIndex)")
//            let maxPrice = chartModels[rightIndex].high
//            visibleCellModelMaxPrices.append(maxPrice)
        }
        
        let visibleMaxPrice = visibleCellMaxPrices.max() ?? 0
        maxPriceLab.text = "可见区域最值：\(visibleMaxPrice)"
        print("可见区域index: \(visibleIndexs.description)")
//        print("可见区域maxPrice: \(visibleCellModelMaxPrices.description)")
    }
}


extension PTKLineViewController: UIScrollViewDelegate {
    
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateVisibleData()
        
    }
    
}

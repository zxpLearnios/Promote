//
//  ChartViewCell.swift
//  TestWlNormal
//
//  Created by Bava on 2019/9/23.
//  Copyright © 2019 Bava. All rights reserved.
//  k线 股票

import UIKit
import SnapKit

class PTKLineCell: UICollectionViewCell {
    
    
    let lab = UILabel()
    var text = "" {
        didSet {
            lab.text = text
        }
    }
    
    let contentLab = UILabel()
    let verticalLab = UILabel()
    
    /// 最大值
    let maxPriceLab = UILabel()
    
    var beginPrice = 0.0
    var endPrice = 0.0
    var highPrice = 0.0
    var lowPrice = 0.0
    let defaultH = 30.0
    
    var labSizeScale = 0.0 {
        didSet {
            if labSizeScale >= 2 {
                labSizeScale = 2
            } else if labSizeScale <= 0.5 {
                labSizeScale = 0.5
            }
            
            lab.transform = CGAffineTransform.init(scaleX: CGFloat(labSizeScale), y: CGFloat(labSizeScale)).concatenating(lab.transform)
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupSubviews() {
        contentView.backgroundColor = .white
        contentView.addSubview(lab)
        lab.center = contentView.center
        lab.bounds = CGRect(x: 0, y: 0, width: 40, height: 30)
        lab.backgroundColor = .red
        
        lab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(contentLab)
        contentView.addSubview(verticalLab)
        contentView.addSubview(maxPriceLab)
        
        maxPriceLab.textColor = .red
        maxPriceLab.font = UIFont.systemFont(ofSize: 10)
        
        contentLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalTo(0)
        }
        verticalLab.snp.makeConstraints { (make) in
            make.center.equalTo(contentLab)
        }
        
        maxPriceLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    func setModel(_ model: PTKLineModel) {
        
        beginPrice = model.open
        endPrice = model.close
        highPrice = model.high
        lowPrice = model.low
        
        
        let isRed = beginPrice <= endPrice
        contentLab.backgroundColor = isRed ? .red : .green
        
        /// 基准1000
        let diffPrice = highPrice - lowPrice
        let muti = diffPrice / 1000.0
        let h = defaultH * muti
        contentLab.snp.updateConstraints { (make) in
            make.height.equalTo(h)
        }
        
        maxPriceLab.text = "\(highPrice)"
    }
    
    
}

//
//  ChartModel.swift
//  TestWlNormal
//
//  Created by Bava on 2019/9/24.
//  Copyright © 2019 Bava. All rights reserved.
//  k线 股票 model

import UIKit

class PTKLineModel: NSObject {

    /// 开盘
    public var open: Double = 0
    
    /// 收盘
    public var close: Double = 0
    
    /// 最高
    public var high: Double = 0
    
    /// 最低
    public var low: Double = 0
    
    /// 成交量
    public var volumefrom: Double = 0
    
    /// 成交额
    public var volumeto: Double = 0
    
    /// 时间
    public var time: TimeInterval = 0
    
    /// 流入
    public var inflow: Double = 0
    
    /// 流出
    public var outflow: Double = 0
    
    /// boll中线
    public var boll_mb: Double = 0
    
    /// boll上线
    public var boll_up: Double = 0
    
    /// boll下线
    public var boll_dn: Double = 0
    
    /// ma5值
    public var ma5: Double = 0
    
    /// ma10值
    public var ma10: Double = 0
    
    /// ma30值
    public var ma30: Double = 0
    
    /// ma60值
    public var ma60: Double = 0
    
    /// volMa5值
    public var volMa5: Double = 0
    
    /// volMa10值
    public var volMa10: Double = 0
    
    /// macd diff线
    public var macd_diff: Double = 0
    
    /// macd dea线
    public var macd_dea: Double = 0
    
    /// macd 柱状图
    public var macd_bar: Double = 0
    
    /// kdj k线
    public var kdj_k: Double = 0
    
    /// kdj d线
    public var kdj_d: Double = 0
    
    /// kdj j线
    public var kdj_j: Double = 0
    
    /// rsi
    public var rsi: Double = 0
}






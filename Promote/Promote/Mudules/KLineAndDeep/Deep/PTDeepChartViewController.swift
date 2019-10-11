//
//  DeepChartViewController.swift
//  TestWlNormal
//
//  Created by Bava on 2019/9/25.
//  Copyright © 2019 Bava. All rights reserved.
//  买盘跟卖盘的数量总是相等的

import UIKit

class PTDeepChartViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let deepChartView = DeepChartView()
        view.addSubview(deepChartView)
    
        deepChartView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(deepChartView.snp_width)
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
   
    
    
    
}

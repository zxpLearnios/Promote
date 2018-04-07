//
//  PTc.swift
//  Promote
//
//  Created by Bavaria on 2018/4/3.
//

import UIKit

class PTTitleScrollerCollectionView: UICollectionView {
    
    
    convenience init (frame: CGRect) {
        // 约束在使用之 的控制器里实现了，故此处的无效且还会导致其他问题
        let fl = UICollectionViewFlowLayout()
        // 这里绝对不能要这句
        //        fl.estimatedItemSize = CGSize.init(width: 100, height: 50)
        fl.scrollDirection = .horizontal
        //        fl.minimumInteritemSpacing = 0 // 水平间距
        fl.minimumLineSpacing = 30 // item 竖直方向的距离
        
        self.init(frame: frame, collectionViewLayout: fl)
        // 禁止用户滚动
        isScrollEnabled = false
        clipsToBounds = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
        
    }
    
}

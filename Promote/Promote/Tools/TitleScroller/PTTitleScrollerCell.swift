//
//  PTcc.swift
//  Promote
//
//  Created by Bavaria on 2018/4/3.
//

import UIKit
import Cartography

class PTTitleScrollerCell: UICollectionViewCell {
    
    
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


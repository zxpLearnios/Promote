//
//  PTBaseTableView.swift
//  Promote
//
//  Created by bavaria on 2018/5/18.
//

import UIKit

class PTBaseTableView: UITableView {

    convenience init() {
        self.init(with: .plain)
    }
    
    convenience init(with style: UITableView.Style) {
        self.init(frame: .zero, style: style)
        setup()
    }
    
    private func setup() {
        separatorStyle = .none
        if style == .grouped {
            let emptyView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.001))
            tableHeaderView = emptyView
        }
        tableFooterView = UIView()
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        keyboardDismissMode = .onDrag
    }

}

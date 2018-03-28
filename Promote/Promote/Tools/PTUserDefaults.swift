//
//  PTUserdefaults.swift
//  Promote
//
//  Created by bavaria on 2018/3/28.
//

import UIKit

class PTUserDefaults: UserDefaults {
    override func setValue(_ value: Any?, forKey key: String) {
        super.set(value, forKey: key)
        synchronize()
    }

}

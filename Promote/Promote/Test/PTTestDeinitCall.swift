//
//  PTTestDeinitCall.swift
//  Promote
//
//  Created by 张净南 on 2018/12/12.
//  测试deinit的调用顺序情况

import UIKit

class PTTestDeinitCall: NSObject {

    /// 调用完子类的deinit后，会自动再去调用父类的deinit方法，因为系统内部已在子类的deinit运行时插入了super.deinit了且不允许自己插入会直接报错的，故会如此执行
    
    
    deinit {
        PTPrint("PTTestDeinitCall deinit")
    }
}


class PTSubTestDeinitCall: PTTestDeinitCall {
    
    deinit {
        PTPrint("PTSubTestDeinitCall deinit")
    }
    
}

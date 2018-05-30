//
//  PTCommonTest.swift
//  Promote
//
//  Created by bavaria on 2018/4/27.
//

import UIKit

class PTCommonTest {

//    var redView = PTCommonTestView()
    
    // 此种写法，redView的生命周期与PTCommonTest一致。即外部局部使用PTCommonTest时，PTCommonTest会立即释放，即redView也会在初始化后立即释放.若全局使用PTCommonTest时。 反正redView不能用weak修饰，否则都会立即释放
    weak var redView: PTCommonTestView!
    
    init() {
//        let a = sortArray()
        
//        do {
//            let result = try testThrow()
//        } catch let err {
//            debugPrint("\(err)")
//        }
        
//        debugPrint(" testDefer \( testDefer())")
       
//        testSwiftNever()
        
        
        
    }
    
    /**
     * 即使是本类为局部使用，即立即释放，但此局部声明的view仍不会释放的。
     * 因为view很特殊，是用来展示的。故
     */
    func testAddViewInPartlyFunc(in superview: UIView) {
        let frame = CGRect(x: 30, y: 100, width: 100, height: 20)
        
//        let view = PTCommonTestView(frame: frame)
//        view.backgroundColor = .red
//        superview.addSubview(view)
        
//        let layer = PTCommonTestLayer()
//        layer.backgroundColor = UIColor.red.cgColor
//        layer.frame = frame
//        superview.layer.addSublayer(layer)
        
//        redView = PTCommonTestView()
//        redView.frame = frame
//        redView.backgroundColor = .red
//        superview.addSubview(redView)
//
        
    }
    
    // 使用非显示类，即非view类或非layer类时，会在此剧本类使用完毕后（如：调用剧本类的很多方法(方法里的子线程的延时操作，不会执行。主线程的延时操作，没测试)并执行完后）立即释放
    func testUseNotViewTypeInPartlyFunc() {
        
        let partlyUseType = PTCommonTestPartlyUseType()
        partlyUseType.delayPrintself() //
        partlyUseType.printself()
        partlyUseType.addMuchData()
    }
    
    
    /**
     * 0. 方法后缀throws，表示此法须使用try catch样式
     */
    func testThrow() throws -> Bool {
        return true
    }
    
    
    /**
     *  1. 将一给定数组里的相同元素放在一个数组里
     */
    func sortArray() -> [[String]] {
        let originAry = ["1", "22", "s", "1", "a", "1", "32", "32", "aa", "s", "s", "22"]
        
//        var indexs = [Int]() // [[String: Int]]()
        var elements = [String]()
        var mutiplySpaceAry = [[String]]()
        
        for i in 0..<originAry.count {
            let element = originAry[i]
            if i == 0 {
                elements.append(element)
                let subAry = [String].init(arrayLiteral: element)
                mutiplySpaceAry.append(subAry)
            } else {
                if elements.contains(element) { // 有相同元素
                    let index = elements.index(of: element)!
                    var subAry = mutiplySpaceAry[index]
                    subAry.append(element)
                    mutiplySpaceAry.remove(at: index)
                    mutiplySpaceAry.insert(subAry, at: index)
                } else {
                    elements.append(element)
                    let subAry = [String].init(arrayLiteral: element)
                    mutiplySpaceAry.append(subAry)
                }
            }
        }
       return mutiplySpaceAry
    }
    
    func testDefer() -> Bool {
        defer {
            debugPrint("defer----")
        }
        return true
    }
    
    func testSwiftNever() -> Never {
       fatalError("testSwiftNever")
    }
    
    deinit {
        debugPrint("PTCommonTest deinit")
    }
    
    
    
}

// ------------  本类测试使用 ------------ //

// 测试此类被局部使用时
class PTCommonTestPartlyUseType {
    
    var ary = [String]()
    
    func addMuchData() {
        for i in 0...10000 {
            ary.append("\(i)")
        }
        debugPrint("最终的数组为 \(ary.debugDescription)")
    }
    
    // 此处的延时，并不能延长生命周期，即不会执行延时block里
    func delayPrintself() {
        
        debugPrint("PTCommonTestPartlyUseType delay print")
        
        delay(2) { [weak self] in
            if let `self` = self {
                debugPrint("PTCommonTestPartlyUseType delay 2 print")
            }
            
        }
    }
    
    func printself() {
        debugPrint("PTCommonTestPartlyUseType print")
    }
    
    deinit {
        debugPrint("PTCommonTestPartlyUseType  deinit")
    }
}
    

// layer只能展示，不能与用户交互
class PTCommonTestLayer: CALayer {
    
   
    
    deinit {
        debugPrint("PTCommonTestLayer deinit")
    }
}

class PTCommonTestView: UIView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("点击了 PTCommonTestView")
    }
    
    deinit {
        debugPrint("PTCommonTestView deinit")
    }
    
}



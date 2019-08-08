//
//  PTTestQueue.swift
//  Promote
//
//  Created by 张净南 on 2019/2/14.
//  测试队列 线程
/**
 1 主队列是串行队列DispathcQueue.main
 同步： 在主线程上执行，不新建线程，操作顺序执行
 异步：在主线程上执行，不新建线程，操作顺序执行
 2 全局队列 DispathcQueue.main.global是并行队列
 同步: 不会新建线程、操作顺序执行
 异步：会新建多个线程、操作无序执行队列前如果有其他任务，会等待前面的任务完成之后再执行
 3 自定义的串行队列
 同步： 在主线程上执行，不新建线程，操作顺序执行
 异步：会新建线程，操作顺序执行（及不影响主线程又需要顺序执行时，特别有用）
 4 自定义的并行队列
 同步： 不新建线程，操作顺序执行
 异步：会新建线程，操作无序执行（有用，容易出错！）队列前如果有其他任务，会等待前面的任务完成之后再执行场景：既不影响主线程，又不需要顺序执行的操作！）
 */

import UIKit

class PTTestQueue {

    let mqueue = DispatchQueue.main
    let gqueue = DispatchQueue.global()
    let squeue = DispatchQueue.init(label: "自定义串行队列")
    let cqueue = DispatchQueue.init(label: "自定义并行队列", attributes: .concurrent)
    
    func test() {
//        mqueue.sync {
//            PTPrint("主队列同步操作时 \(Thread.current)")
//        }
//        mqueue.async {
//            PTPrint("主队列异步操作时 \(Thread.current)")
//        }
        
        gqueue.sync {
            PTPrint("全局队列同步操作时 \(Thread.current)")
        }
        gqueue.async {
            PTPrint("全局队列异步操作时 \(Thread.current)")
        }
        
//        squeue.sync {
//            PTPrint("自定义串行队列同步操作时 \(Thread.current)")
//        }
//        squeue.async {
//            PTPrint("自定义串行队列异步操作时 \(Thread.current)")
//        }
//
//        cqueue.sync {
//            PTPrint("自定义并行队列同步操作时 \(Thread.current)")
//        }
//        cqueue.async {
//            PTPrint("自定义并行队列异步操作时 \(Thread.current)")
//        }
        
    }
    
}

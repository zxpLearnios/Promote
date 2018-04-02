//
//  PTTest.swift
//  Promote
//
//  Created by Bavaria on 29/03/2018.
//  Subject是一个代理，它既是Observer，也是Observable。因为它是一个Observer，它可以订阅一个或多个Observable;因为它是一个Observable，它又可以被其他的Observer订阅。它可以传递/转发作为Observer收到的值，也可以主动发射值。
//  所有的类型都可以受到订阅后的 所有发出的信息
// 只要是同一个信号发送了error或completed，则之后再发送的信息都不会被订阅者观察到了
//  订阅规则： （如果代码在一个地方的话）一般是先发信息，后订阅，
/**
 // dispose(by 后会对disposeBag弱引用，故disposeBag应该所谓当前实例的属性，随当前实例一起销毁，从而使得RxSwift在此实例上绑定的资源得到释放。
    labObservable.bindTo(self.lab.rx.text).dispose(by: disposeBag)
 */

import UIKit
import RxCocoa
import RxSwift


public final class PTTest: NSObject {
    
    var db:DisposeBag?
    override init() {
        super.init()
        
//        disposeBag = DisposeBag()
        db = DisposeBag()
        // 0.
        let publicSubject = PublishSubject<String>.init()
//        publicSubject.onNext("begin-onNext") // 不会打印
//        publicSubject.onCompleted()
//        // 此类型，不会受到订阅前的信息(其中error和completed除外)
//        publicSubject.subscribe({ element in
//            debugPrint("publicSubject: \(element)")
//        }).disposed(by: kdisposeBag)
//
//        publicSubject.onNext("goon-onNext")
//        publicSubject.onCompleted()
        // 0.1 每隔3s发射一组信号，信号个数<=3，不足的话则发射[]， //每缓存3个元素则组合起来一起发出。如果3s内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
//        publicSubject.buffer(timeSpan: 3, count: 3, scheduler: MainScheduler.instance).subscribe({
//            debugPrint("publicSubject buffer发射：", $0)
//        }).disposed(by: disposeBag)
//
//        delay(2) {
//            publicSubject.onNext("a")
//            publicSubject.onNext("b")
//            publicSubject.onNext("c")
//        }
//        delay(6) {
//            publicSubject.onNext("1")
//            publicSubject.onNext("2")
//            publicSubject.onNext("3")
//        }
//        delay(10) {
//            publicSubject.onCompleted()
//        }
        
        
        // 1. ReplaySubject和PublishSubject不同的是：Observer有可能接收到订阅之前 发出的bufferSize个信息，其中error和completed信息也可以收到但不算个数,
//        let replaySubject = ReplaySubject<Any>.create(bufferSize: 2)
//        replaySubject.onNext("有可能会受到的信息a")
//        replaySubject.onNext("有可能会受到的信息b")
//        replaySubject.onNext("有可能会受到的信息c")
////        replaySubject.onCompleted()
//        replaySubject.subscribe({
//            debugPrint("replaySubject\($0)")
//        }).disposed(by: kdisposeBag)
//        replaySubject.onNext("如果此信号以发送过error或completed信息，则之后再发送的信息都不会被订阅者观察到了")
//        replaySubject.onNext("这是订阅后的发出的第一条信息")
//        replaySubject.onNext(2)
//        replaySubject.onNext("这是订阅后的最后一条信息")
//        replaySubject.onCompleted()
//        replaySubject.single().asMaybe().subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        
        // 2. BehaviorSubject类似于ReplaySubject具有缓存能力，但是略有不同.只缓存一个最新值即只接受订阅前发送的最后一条信号，类似ReplaySubject.create(bufferSize: 1)
        // 其中error和completed信息也可以收到且算个数）
//        let behaviorSubject = BehaviorSubject<Int>.init(value: 0)
//        behaviorSubject.onCompleted()
//        behaviorSubject.onNext(1)
//        behaviorSubject.onNext(2)
//        behaviorSubject.subscribe({
//            debugPrint("behaviorSubject的观察者收到的信息：\($0)")
//        }).disposed(by: kdisposeBag)
//        behaviorSubject.onNext(3)
        
        // 3. Variable和BehaviorSubject又很相似，Variable是BehaviorSubject的一个封装，同样具备了缓存最新值和提供默认值的能力。但是Variable没有on系列方法，只提供了value属性。 直接对value进行set等同于调用了onNext()方法。这表明了Variable不会发射error也不会发射completed.在Variable被销毁的时候会调用发射completed给观察者。
//        let variableSubject = Variable<String>.init("这是发送的第一个信号")
//        variableSubject.asObservable().subscribe({ observe in
//            debugPrint("variableSubject: \(observe)")
//        }).disposed(by: kdisposeBag)
//        variableSubject.value = "1111"
        
        // 3. Variable已经过期，用BehaviorRelay代替。不会发射error和completed，只能收到订阅前的最后一个信息和订阅后的所有信息
        /** 三种序列
         HistoricalScheduler
         CurrentThreadScheduler
         ConcurrentDispatchQueueScheduler
         */
//        let behaviorReplay = BehaviorRelay<String>.init(value: "这是发送的第一个信号")
//        behaviorReplay.accept("这是发送的第二个信号")
//        behaviorReplay.accept("1---")
//        behaviorReplay.subscribeOn(CurrentThreadScheduler.instance).subscribe({ observe in
//            debugPrint("behaviorReplay: \(observe)")
//        }).disposed(by: kdisposeBag)
//        behaviorReplay.accept("这是订阅后发送的信息")
        
//        var e = Driver<Bool>.just(false)
//        e.asObservable().single().subscribe({ e in
//            debugPrint("---", e.element)
//        })
//        e = Driver<Bool>.just(true)
    }
    
    // 的Init方法，用处不太大，因为有时属性会在deinit几秒后才会销毁
    deinit {
        let obj = self
        delay(3) {
            let a = (obj.db == nil)
            debugPrint("PTTest 销毁了, )", a)
        }
    }
}


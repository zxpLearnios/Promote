//
//  PTTestRealm.swift
//  Promote
//
//  Created by Bavaria on 2018/5/23.
//  realm数据库
//  1. 数据库只能在当初创建的线程里使用，不能跨线程 2. 对象必须直接继承RealmObject，间接继承不行 3. 主键不能自增 4. 数据库升级后不能降

import UIKit
//import Realm
import RealmSwift

class PTTestRealm {
    
    // （每个线程）只需执行一次
    var realm: Realm?
    
    
    /// 用于测试realm创建多个不同的数据库
    static let configForPeopleInfo: Realm.Configuration = {
        let path = kdocumentsDirectory.last! + "/people.realm"
        // 创建文件
        if !PTFileOperatorManager.isFileExistAtPath(path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        let url = URL.init(string: path)
        // 必须是可读写的
        let config = Realm.Configuration.init(fileURL: url,  readOnly: false, schemaVersion: 1)
        return config
    }()
    
    static let peopleRealm: Realm = {
        // 使用该配置来打开 Realm 数据库
        let realm = try! Realm(configuration: configForPeopleInfo)
        // 打开
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                PTPrint("peopleRealm 数据库配置成功")
            }
        }
        return realm
    }()
    
    
    static let configForDefaultInfo: Realm.Configuration = {
        let path = kdocumentsDirectory.last! + "/default.realm"
        // 创建文件
        if !PTFileOperatorManager.isFileExistAtPath(path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
        let url = URL.init(string: path)
        // 必须是可读写的
        let config = Realm.Configuration.init(fileURL: url,  readOnly: false, schemaVersion: 1)
        return config
    }()
    
    static let defaultRealm: Realm = {
        // 使用该配置来打开 Realm 数据库
        let realm = try! Realm(configuration: configForDefaultInfo)
        // 打开
        Realm.asyncOpen { (realm, error) in
            if let _ = realm {
                PTPrint("defaultRealm 数据库配置成功")
            }
        }
        return realm
    }()
    
    // ------------------
    
    
    init() {
        configRealm()
        realm = getRealm()
        
//        DispatchQueue.global().async { [weak self] in
//            if let `self` = self {
//                self.realm = self.getRealm()
//            }
//        }
    }
    
    func getRealm() -> Realm? {
         return try? Realm()
    }
    
    
    func configRealm() {
        if let lastRealmVersion = kUserDefaults.value(forKey: ksavceRealmVersionKey) as? Int {
//            if lastRealmVersion > 指定版本 {
//                // 需要进行数据迁移
//            }
            
        } else { // 首次使用数据库
            kUserDefaults.set(1, forKey: ksavceRealmVersionKey)
            kUserDefaults.synchronize()
        }
        
        
        
        var realmConfig = Realm.Configuration() // defaultConfiguration
        // 测试发现设置为0，会一直配置失败。故schemaVersion > 0
        realmConfig.schemaVersion = 3
        
//        c.inMemoryIdentifier = ""
//        c.readOnly = false
//        c.fileURL =
        // 数据库迁移. 只有本次的版本号\schemaVersion 必须大于以前的schemaVersion，才会触发此回调。 若<以前的schemaVersion则会配置失败
        realmConfig.migrationBlock = {[weak self] migration, oldSchemaVersion in
            if oldSchemaVersion < 3 {
                debugPrint("需要将数据库迁移了")
                migration.enumerateObjects(ofType: PTTestRealmPeopleModel.className(), {oldObject, newObjec in
                    debugPrint("在这里将旧版本的app里数据库里存的值进行处理，数据迁移处理")
                })
            }
            
        }
        Realm.Configuration.defaultConfiguration = realmConfig
        debugPrint("数据库路径：\(realmConfig.fileURL?.absoluteString)")
        // 打开
        Realm.asyncOpen { (realm, error) in
            
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                
                print("Realm 数据库配置成功")
            }
                /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
        
    }
    
    
    func add() {
        let total: uint = 10
        for i in 0...total {
            let peopleA = PTTestRealmPeopleModel()
            peopleA.name = "aa\(i)"
            peopleA.age = Int(arc4random() % total)
            
            let peopleB = PTTestRealmPeopleModel()
            peopleB.name = "bb\(i % 2)"
            peopleB.age = Int(arc4random() % total)
            
            let partA = PTTestRealmPartModel()
            partA.name = "第\(arc4random() % total)部"
            
            let partB = PTTestRealmPartModel()
            partB.name = "第\(arc4random() % total)部"
            
            peopleA.setValue(partA, forKey: "part")
            peopleB.setValue(partB, forKey: "part")
            partA.setValue([peopleA, peopleB], forKey: "peoples")
            
            DispatchQueue.global().async { [weak self] in
                
                if let `self` = self {
                    do {
                        
                        let realm = try  Realm()
                        try? realm.write { [weak self] in
                            if let `self` = self {
                                debugPrint("1111 \(Thread.current)")
                                realm.add(peopleA)
                                //                                self.realm?.add(peopleA)
//                                self.realm?.add(peopleB)
//                                self.realm?.add(partA)
//                                self.realm?.add(partB)
                                //                self.realm?.add(<#T##object: Object##Object#>, update: <#T##Bool#>)
                                //                self.realm?.create(PTTestRealmPeopleModel.self, value: ["name": "张三"], update: true)
                            }
                            
                        }
                    } catch {
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    func query() {
        
//        try? realm?.write { [weak self] in
//            if let `self` = self {
//                let parts = self.realm?.objects(PTTestRealmPartModel.self)
//
//                debugPrint("查询到的parts： \(parts.debugDescription)")
//            }
//
//        }
        // 根据primarykey获取指定对象
//        self.realm?.object(ofType: PTTestRealmPartModel, forPrimaryKey: "")
        
        // 过滤, 即将结果集Result数组过滤
        /**
         1. [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
         */
        // LIKE时必须加通配符*，否则还是用contains, 里面的操作字符不分大小写
//        let predicate = // "name contains[cd] %@", "0"; peoples.@count > 10; age > 10 OR name BEGINSWITH 'a'
        let predicate = PTBasePredicate.query(for: "age", from: 8, to: nil) //ishaveSuffix(in: "name", suffix: "b1") //ishaveSuffix(in: "name", suffix: "a1") //ishavePrefix(in: "name", prefix: "第0部") //isContainString(in: "name", string: "1部")
        let result = self.realm?.objects(PTTestRealmPeopleModel.self).filter(predicate)  // self.realm?.objects(PTTestRealmPartModel.self).map({$0.peoples})  //self.realm?.objects(PTTestRealmPeopleModel.self).sorted(byKeyPath: "name", ascending: true) // self.realm?.objects(PTTestRealmPeopleModel.self).filter(predicate)
        
        debugPrint("过滤后的结果为： \(result.debugDescription)")
    }
    
    func delete() {
        try? realm?.write { [weak self] in
            if let `self` = self {
               self.realm?.deleteAll()
            }
            
        }
    }
    
    
}

/**
 1. 主键不支持自增长属性，支持Int、string
 2. Realm 模型属性必须使用 @objc dynamic var 特性，从而让其能够访问底层数据库的数据。注意，如果这个类 被 @objcMembers 所声明（Swift 4 以及之后的版本），那么各个属性可以只使用 @objc dynamic var 来声明。
 不过有三种例外情况：LinkingObjects、List 以及 RealmOptional。这些属性不能声明为动态类型，因为泛型属性无法在 Objective-C 运行时中正确表示，而这个运行时是用来对 @objc dynamic 属性进行动态调度的。这些属性应当始终用 let 进行声明。
 3. @objcMembers 比@objc高效
 4. realm 对象 只能在首次所创建的线程中访问. 尤其需要注意
 5. 将 KVC 应用在集合当中是大量更新对象的极佳方式，这样就可以不用经常遍历集合
 6.
 */
@objcMembers class PTTestRealmPeopleModel: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    @objc dynamic var learnOritation = ""
    var isLikeUS: RealmOptional<Bool>?
    @objc dynamic var haveGoCountry: String?
    
    
//    var part: PTTestRealmPartModel?
    // 建立外键关联\互联。好像外部不能直接初始化使用，这里使用setValueforkey处理
    var part = LinkingObjects.init(fromType: PTTestRealmPartModel.self, property: "peoples")
    
    
    // 声明主键之后，对象将允许进行查询，并且更新速度更加高效，而这也会要求每个对象保持唯一性。 一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // 会提升效率
    @objc override class func indexedProperties() -> [String] {
        return ["name", "age"]
    }
    
    // 不需要存储到数据库的属性
    override class func ignoredProperties() -> [String]{
        return ["oritation"]
    }
}

@objcMembers class PTTestRealmPartModel: Object {
    // 主键必须这样写。像let id = "'是不行的
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    var peoples = List<PTTestRealmPeopleModel>()
    
    // 声明主键之后，对象将允许进行查询，并且更新速度更加高效，而这也会要求每个对象保持唯一性。 一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
    override class func primaryKey() -> String? {
        return "id"
    }
    
    
    // 会提升效率
    @objc override class func indexedProperties() -> [String] {
        return ["name", "peoples"]
    }
    
}


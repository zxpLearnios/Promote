//
//  Config.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.



import UIKit
import Alamofire

import AddressBook // ios8
import AddressBookUI // ios8
import  Contacts // ios9
import ContactsUI

import CoreLocation



class Config: NSObject {
    

    /** 信息提示label */
    private var msgLabel:PTMsgLabel!
    // MARK: 单例
    static let shareInstanceObj = Config()
    class var shareInstance:Config {
        return shareInstanceObj
    }

    /**
     弹框提醒  ==  khud.showPromptText
     */
    class func showAlert(withMessage message:String)
    {
        khud.showPromptText(message)
    }
    
    /**
     * 1. 弹框提醒，有取消或确定按钮的
     *  外部传入的cancleTitle为空时，则无取消按钮了，只剩下确定按钮
     */
    class func showAlert(withDelegate delegate:AnyObject?, title: String, message: String?, cancleTitle:String?, confirmTitle:String){
        
        let alert = UIAlertView() // UIAlertView.init(title: title, message: message, delegate: nil, cancelButtonTitle: cancleTitle, otherButtonTitles: confirmTitle)
        alert.delegate = delegate
        alert.title = title
        alert.message = message
        
        if cancleTitle != nil {   
            alert.addButton(withTitle: cancleTitle)
        }
        
        alert.addButton(withTitle: confirmTitle)
        
        alert.show()
       
    }
    
    
    /** 网络状态的改变   */
    func networkStatusChanged(){
        // 监听网络状态的改变
        let manager = NetworkReachabilityManager.init()
        manager?.listener = { status in
            if status == .notReachable {
                self.opeateStuatusBar("没有网络/断网")
            }else if status == .unknown {
                self.opeateStuatusBar("未知网络")
            }else{
                if status == .reachable(.ethernetOrWiFi) {
                    self.opeateStuatusBar("您正在使用wifi")
                }else{ // WWAN 您正在使用无线广域网
                    self.opeateStuatusBar("手机自带网络")
                }
            }
        }
        manager?.startListening()
        
        if msgLabel == nil {
            msgLabel = PTMsgLabel.init(frame: CGRect(x: 0, y: -18, width: kwidth, height: 18))
        }
        kwindow?.addSubview(msgLabel)
    }
    
    // 操作状态栏
    private func opeateStuatusBar(_ error:String){
        msgLabel.errorMessage = error
        kwindow!.windowLevel = UIWindowLevelAlert
        self.perform(#selector(statusBarRevert), with: self, afterDelay: 3)
    }
    
    // 状态栏恢复
    @objc private func statusBarRevert(){
        kwindow!.windowLevel = UIWindowLevelNormal
        msgLabel.isHidden = true
    }
    
    // MARK: 通讯录授权
    final class func isHaveAccessForContacts() -> Bool {
        // 注意bundle display name 在ios9时需设置和自己的实际名字一样才可以访问通讯录，不然会一直失败，在setting里设置app名字无用，还是一直失败的。 总之，不好找！
        
        var isAccess = false
        
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            
            if  status == .authorized {
                debugPrint("ios9已对通讯录授权")
                isAccess = true
            }else if status == .notDetermined {
                let  store = CNContactStore.init()
                store.requestAccess(for: .contacts, completionHandler: {    (granted, error) in
                    if granted {
                        debugPrint("ios9通讯录授权成功！")
                        isAccess = true
                    }else{
                        debugPrint("ios9通讯录授权失败！\(error)")
                        isAccess = false
                    }
                })
                
            }else{ // 拒绝  受限制
                debugPrint("ios9拒绝\\受限制通讯录授权")
                isAccess = false
            }
            
            
        }
        else { // 非 ios9
            // 1. 通讯录
            let status = ABAddressBookGetAuthorizationStatus()
            
            if  status == .denied { // 拒绝访问
                isAccess = false
            }else if status == .restricted{ // 受限制的
                isAccess = false
            }else if status == .notDetermined{ // 不确定 首次访问相应内容会提
                // 创建通讯录
                let  addressBook = ABAddressBookCreateWithOptions(nil, nil) as? ABAddressBook
                //                if addressBook == nil {
                //                    return
                //                }
                
                // 访问通讯录
                ABAddressBookRequestAccessWithCompletion(addressBook, { (granted, error) in
                    if granted {
                        debugPrint("ios8通讯录授权成功！")
                        isAccess = true
                    }else{
                        debugPrint("ios8通讯录授权失败！\(error)")
                        isAccess = false
                    }
                    
                })
            }else{ // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
                debugPrint("ios8已对通讯录授权")
                isAccess = true
            }
            
            
        }
        return isAccess
        
    }

    // MARK: 获取通讯录里所有的联系人信息 无UI（ios8、9）  在主队列（串行的）异步操作  // 过滤掉360的黑名单、白名单库
    final class func getAllContactsWithoutUI() -> [[String:AnyObject]]{
        var contactsAry = [[String:AnyObject]]()
        
        // 1. 获取联系人仓库
        if #available(iOS 9.0, *) {
            let store = CNContactStore()
            
            // 2. 创建联系人信息的请求对象
            let  keys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
            
            // 3. 根据请求Key, 创建请求对象
            let fetchRequest = CNContactFetchRequest.init(keysToFetch: keys as [CNKeyDescriptor])
            
            // 4. 发送请求
            do{
                try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) in
                    
                    // 获取姓名 全名 givenName == firstName   familyName== lastName
                    let name = contact.familyName + contact.middleName + contact.givenName
                    
                    // 获取联系方式
                    let phoneAry = contact.phoneNumbers
                    
                    // 将所有的手机号拼接
                    var phoneStr = ""
                    if phoneAry.count == 0 || phoneAry.count >= 10 { // 过滤掉360的黑、白名单
                        
                    }else{
                        let count = phoneAry.count
                        for i in 0..<count {
                            let labelValue = phoneAry[i]
                            if let phoneNumber = labelValue.value as? CNPhoneNumber {
                                let phone = (phoneNumber.stringValue) ?? ""
                                //  // 拼接所有的手机号  ， 多个手机号之间有逗号分开
                                if phoneAry.count == 1 {
                                    phoneStr = phone
                                }else {
                                    if i == count - 1 {
                                        phoneStr += phone
                                    }else{
                                        phoneStr += phone + ","
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    // 当前的联系人字典
                    let contactDic = ["name":name, "mobile":phoneStr]
                    // 将当前联系人添加到联系人数组
                    contactsAry.append(contactDic as [String : AnyObject])
                })
                
            } catch{
                
                
            }
            
            
        } else {
            
            // 1. 声明一个通讯簿的引用
            // 2. 创建通讯簿的引用
            if ABAddressBookCreateWithOptions(nil, nil) == nil {
                return []
            }
            
            let addBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            // 3. 创建一个出事信号量为0的信号
            //            let  sema = dispatch_semaphore_create(0)
            
            //发送一次信号
            //            dispatch_semaphore_signal(sema)
            
            // 4. 等待信号触发 马上触发
            //            dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)
            
            // 5. 获取所有联系人的数组
            if ABAddressBookCopyArrayOfAllPeople(addBook) == nil { // 通讯录里没有联系人
                debugPrint("联系人数组为空！")
                return []
            }
            
            // 对于类似 ABAddressBookCopyArrayOfAllPeople(addBook!) -> Unmanaged<CFArray>!，必须先takeRetainedValue后才能转成其他类型
            let  allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook).takeRetainedValue()
            
            
            // 6. 获取联系人总数
            for people in  allLinkPeople as NSArray {
                
                // 7. 获取全名
                var firstName:String?
                var middleName:String?
                var lastName:String?
                
                if  ABRecordCopyValue(people as ABRecord!, kABPersonFirstNameProperty) != nil {
                    firstName =  ABRecordCopyValue(people as ABRecord!, kABPersonFirstNameProperty).takeRetainedValue() as? String
                }
                if  ABRecordCopyValue(people as ABRecord!, kABPersonMiddleNameProperty) != nil {
                    middleName =  ABRecordCopyValue(people as ABRecord!, kABPersonMiddleNameProperty).takeRetainedValue() as? String
                }
                if ABRecordCopyValue(people as ABRecord!, kABPersonLastNameProperty) != nil {
                    lastName =  ABRecordCopyValue(people as ABRecord!, kABPersonLastNameProperty).takeRetainedValue() as? String
                }
                
                
                var f = ""
                var m = ""
                var l = ""
                
                if firstName != nil {
                    f = firstName!
                }
                
                if middleName != nil{
                    m = middleName!
                }
                if lastName != nil{
                    l = lastName!
                }
                
                let name = l + m + f
                
                // 8. 获取当前联系人的电话 数组
                var phoneStr = ""
                if ABRecordCopyValue(people as ABRecord!, kABPersonPhoneProperty) == nil {
                    
                }else{
                    let  phones = ABRecordCopyValue(people as ABRecord!, kABPersonPhoneProperty).takeRetainedValue()
                    let count = ABMultiValueGetCount(phones)
                    if count == 0 || count >= 10{ // 没有手机号, 过滤掉360的黑、白名单（有几千条数据）
                        
                    }else{
                        for j  in 0..<count {
                            if ABMultiValueCopyValueAtIndex(phones, j) == nil {
                                continue
                            }
                            if let phone = ABMultiValueCopyValueAtIndex(phones, j).takeRetainedValue() as? String  {
                                // 拼接所有的手机号  ， 多个手机号之间有逗号分开
                                if count == 1 {
                                    phoneStr += phone
                                }else{
                                    if j == count - 1 {
                                        phoneStr += phone
                                    }else{
                                        phoneStr += (phone + ",")
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    
                }
                // 当前的联系人字典
                let contactDic = ["name":name, "mobile":phoneStr]
                
                // 将当前联系人添加到联系人数组
                contactsAry.append(contactDic as [String : AnyObject])
            }

                
        }
        
        return contactsAry
    }

}







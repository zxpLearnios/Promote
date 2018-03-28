//
//  String+extension.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.

import UIKit


extension String{

    /**
     -1 .去除空格
     */
    static func deleteBlanks(primaryStr str:String) -> String{
        return str.replacingOccurrences(of: " ", with: "")
    }
    
    /**
     * 0. 是否符合身份证号 格式 ， 15\18位
     */
    static func verityIdCardFormat(_ text:String) -> Bool {
        let format = "^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$" // init(format: "SELF MATCHES %@", arguments: <#T##CVaListPointer#>)
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", argumentArray: Array.init(repeating: format, count: 1))
        if predicate.evaluate(with: text){
            return true
        }else{
            return false
        }
    }
    
    /**
     *  1. 判断密码格式：6--14位数字与字母的组合。 传入的密码只判断格式
     */
    static func verityPasswordFormat(_ password:String) -> Bool{
        
        let regex = "^(?=.*?[a-zA-Z])(?=.*?[\\d])[a-zA-Z\\d]{6,14}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: password)
    }
    
    
    /**
     *  2. 是否全是数字
     */
    static func isAllNumber(_ string:String) -> Bool{
        let number = "^[0-9]+$"
        let numberPre = NSPredicate.init(format: "SELF MATCHES %@", number)
        return numberPre.evaluate(with: string)
    }
    
    
    /**
     *   3. 右至左 每三位分割, 传double、Int都可
     */
    static func sepretorStringWithCharactor(_ obj: String) -> String{
        let charPoint = "."
        let char:Character = "," // 分割的逗号
        
        let charPointIndex = obj.range(of: charPoint)
        var  zNumber = ""// 整数部分字符
        
        var xNumber = "" // 小数部分
        var newStr = "" //新的整数部分字符串
        var result = "" // 最终结果
        
        
        //***********      判断的都是整数部分的长度  ************//
        
        if charPointIndex == nil { // 无小数部分，即原数为整数
            xNumber = ""
            zNumber = obj // 整数部分字符
        }else{ // 原数为含小数
            zNumber = obj.components(separatedBy: charPoint).first! // 整数部分字符
            xNumber = charPoint + obj.components(separatedBy: charPoint).last!
        }
        
        newStr = zNumber
        
        let count = newStr.characters.count // 整数部分的长度
        let  discuss = count / 3 // 商 （整数商）
        let remainder = count % 3 // 余数
        
        if  remainder == 0 { // 整除时
            
            if discuss == 1 { // 3位时
                
            }else{ // 3n位时
                for i in 1..<discuss {
                    let  muti = i * 3 + (i - 1)
                    let start = newStr.characters.index(newStr.endIndex, offsetBy: -muti)
                    newStr.insert(char, at: start)
                }
            }
            
            
        }else{ // 不能整除时
            if discuss == 0 { // < 3位时
                
            }else{ //  >=3 位时
                for i in 1...discuss {
                    let  muti = i * 3 + (i - 1)
                    let start = newStr.characters.index(newStr.endIndex, offsetBy: -muti)
                    newStr.insert(char, at: start)
                }
            }
            
            
        }
        
        result = newStr + xNumber
        
        return result
    }

    /**
     *  4. 是否是直辖市\自治市, 服务器返回的市可能带有空格，故这里需过滤掉头尾的空格
     */
    static func isMunicipalities(_ str:String) -> Bool{
        let newStr = str.replacingOccurrences(of: " ", with: "")
        if newStr == "北京市" ||  newStr == "天津市" ||  newStr == "上海市" ||  newStr == "重庆市" {
            return true
        }else{
            return false
        }
        
    }
    
    /**
     *  5. 判断此项目的联系人姓名  汉字或中位点“.”组成
     */
    static func isLegalForLinkmanName(_ str:String) -> Bool{
        let number = "^[\\u4e00-\\u9fa5·]{0,}$" //  ^[\\u4e00-\\u9fa5]{0,}$
        let numberPre = NSPredicate.init(format: "SELF MATCHES %@", number)
        return numberPre.evaluate(with: str)
    }
    
    
    /**
     *  6. 手机号格式判断
     */
    static func verityNewEstMobileFormat(_ mobileNum:String) -> Bool{
        
        if (mobileNum.characters.count != 11){
            return false
        }
        /**
         * 手机号码:
         * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
         * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         * 联通号段: 130,131,132,155,156,185,186,145,176,1709
         * 电信号段: 133,153,180,181,189,177,1700
         */
        let mobile = "^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$"
        /**
         * 中国移动：China Mobile
         * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
         */
        let cm = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)"
        /**
         * 中国联通：China Unicom
         * 130,131,132,155,156,185,186,145,176,1709
         */
        let cu = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)"
        /**
         * 中国电信：China Telecom
         * 133,153,180,181,189,177,1700,173
         */
        let ct = "(^1(33|53|77|73|8[019])\\d{8}$)|(^1700\\d{7}$)"
        
        
        let regextestmobile = NSPredicate.init(format: "SELF MATCHES %@", mobile)
        let regextestcm = NSPredicate.init(format: "SELF MATCHES %@", cm)
        let regextestcu = NSPredicate.init(format: "SELF MATCHES %@", cu)
        let regextestct = NSPredicate.init(format: "SELF MATCHES %@", ct)
    
        if ( regextestmobile.evaluate(with: mobileNum)
        || regextestcm.evaluate(with: mobileNum)  || regextestct.evaluate(with: mobileNum)  || regextestcu.evaluate(with: mobileNum)){
            return true
        }else{
            return false
        }
        
//        let phoneRegex = "^((+?86)|(+86))?(1[0-9]{10})$"
//        let phoneTest:NSPredicate = NSPredicate.init(format:"SELF MATCHES %@", phoneRegex)
//        let isMatch:Bool = phoneTest.evaluateWithObject(mobileNum)
//        return isMatch
        
    }

    
    
}

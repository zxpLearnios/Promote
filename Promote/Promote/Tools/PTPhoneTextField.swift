//
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  1. 若将phoneNumberFormat公开，则在shouldChangeCharactersInRange里调用即可，无须做任何其他的处理    2. 由于在下 4 里 加入了3句截取长度，故外界不须做任何处理了  3. 344格式

import UIKit

class PTPhoneTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(self.phoneNumberFormat), for: .editingChanged)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.phoneNumberFormat), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     返回bool，时为了方便外部textFiled的代理也可以在shouldChangeCharactersInRange里主动调此法
     *  已限制了位数，外部无须做任何处理
     */
     @objc fileprivate func phoneNumberFormat() -> Bool{
        
        var text = self.text! as NSString
        
        // 1. 只能输入数字
        let characterSet = CharacterSet.decimalDigits//NSCharacterSet.init(charactersInString: "0123456789\\b")
        
        // 1.0 无用, 但若外部在shouldChangeCharactersInRange调用值，则须打开
//        let newReplaceStr = replaceString.stringByReplacingOccurrencesOfString(" ", withString: "")
////        debugPrint("\(replaceString) , \(newReplaceStr)")
//        if ((newReplaceStr.rangeOfCharacterFromSet(characterSet.invertedSet)) != nil) {
//            return false
//        }

//        text = text.stringByReplacingCharactersInRange(range, withString: newReplaceStr)
      
        // 1.1 过滤掉空格
        text = text.replacingOccurrences(of: " ", with: "") as NSString //replacingOccurrences(of: " ", with: "")
        
        // 2. 在text头部加空格
        let temString = NSMutableString.init(string: text)
        temString.insert(" ", at: 0)
        text = temString as NSString
        
        
        // 3. fromIndex包含当前index，toIndex不包含当前index
        // 若 str = "123", 则toIndex最大==fromIndex最大 == str.length, 即获取了自己;
        var newString = ""
        while text.length > 0
        {
            // 获取全部的text
            let subString = text.substring(to: min(text.length, 4))
            
           
            newString = newString + subString
            
            if subString.count == 4
            {
                newString = newString + " "
            }
            text = text.substring(from: min(text.length, 4)) as NSString
        }
        // 3.1 characterSet.invertedSet 将characterSet反转成set; 即去掉newString的头部空格
        newString = newString.trimmingCharacters(in: characterSet.inverted)
        
        // 4. 号码14 银行卡 24
        if newString.count >= 14
        {
            // 有了这三句，外部就不用做任何长度限制处理了. 实际上此时也不用返回bool了,只有外部shouldChangeCharactersInRange不调之
            let end = newString.index(newString.startIndex, offsetBy: 13)
            newString = newString.substring(to: end)
            self.text = newString
            
            return false
        }
        
        self.text = newString
        return false
        
    }
    
    
}

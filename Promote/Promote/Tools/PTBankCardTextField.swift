//
//  QLBankCardTextField.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  1. 外部须限制长度  2. 四位一空格

/*
 银行卡分借记卡、准贷记卡、贷记卡三种，而银行卡一般都携带银联、Visa、Master、JCB等标志。
 一般以6开头的卡是银联卡，以4开头的卡是携带Visa标志的卡，以5开头的卡是携带Master的卡，以3开头的是携带JCB标志的卡。
 
 一个银行的的卡里面带有同一个标志的卡的前几位数字是一样的，譬如招商银行，带银联标志的卡以62258开头，带Visa的标志以4392开头，带Master标志的以5186开头，带JCB的以3568开头。
 
 另外一个银行的借记卡和贷记卡的卡号位数一般不一样，
 譬如建设银行，借记卡以4367开头，是19位，而带Visa标志的贷记卡也以4367开头，但是是16位的。
 一般贷记卡的卡号位数都是16位，借记卡位数根据银行不同，是16位到19位不等
 
 工行现在的卡都是19位的
 农行卡可以分为借记卡、准贷记卡和贷记卡。
 农行借记卡有19位
 农行信用卡是16位
 开头五位是95599
 */



import UIKit

class PTBankCardTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
         self.addTarget(self, action: #selector(self.bankCardNumberFormat), for: .editingChanged)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.bankCardNumberFormat), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    /**
     返回bool，时为了方便外部textFiled的代理也可以在shouldChangeCharactersInRange里主动调此法
     *  外部须限制位数
     */
    @objc fileprivate func bankCardNumberFormat() -> Bool{
        
        var text = self.text! as NSString
        
        // 1. 只能输入数字
        let characterSet = CharacterSet.decimalDigits
        
        // 1.0 无用。但若外部在shouldChangeCharactersInRange调用值，则须打开
        //        let newReplaceStr = replaceString.stringByReplacingOccurrencesOfString(" ", withString: "")
        ////        debugPrint("\(replaceString) , \(newReplaceStr)")
        //        if ((newReplaceStr.rangeOfCharacterFromSet(characterSet.invertedSet)) != nil) {
        //            return false
        //        }
        //
        //
        //        text = text.stringByReplacingCharactersInRange(range, withString: newReplaceStr)
        
        // 1.1 过滤掉空格
        text = text.replacingOccurrences(of: " ", with: "") as NSString
        
        
        // 2. fromIndex包含当前index，toIndex不包含当前index
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
        // 2.1 characterSet.invertedSet 将characterSet反转成set; 即去掉newString的头部空格
        newString = newString.trimmingCharacters(in: characterSet.inverted)
        
        // 3. 银行卡 24 ，此处为限制位数，之后外部无须再限制位数了
//        if newString.characters.count >= 24
//        {
//            // 有了这三句，外部就不用做任何长度限制处理了. 实际上此时也不用返回bool了,只有外部shouldChangeCharactersInRange不调之
//            let end = newString.startIndex.advancedBy(23)
//            newString = newString.substringToIndex(end)
//            textField.text = newString
//            
//            return false
//        }
        
        self.text = newString
        return false
        
    }
    
    
}

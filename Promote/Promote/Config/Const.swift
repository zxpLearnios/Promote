//
//  Const.swift
//  Promote
//
//  Created by 张净南 on 2018/3/22.
//  全局量

import UIKit
import RxSwift
import Alamofire

// com.zjn.www.Promote
// group.com.zjn.www.Promote.SharePromote

let krealmVersion = 1
let ksavceRealmVersionKey = "ksavceRealmVersionKey_key"

let ApiType = "dev://..."
// xcode里直接创建即可，或登录开发者账号创建
let appGroupskey = "group.com.zjn.www.Promote.SharePromote" //"appGroupskey_key"
let kreachabilityManager = NetworkReachabilityManager.init()
//let kdisposeBag = DisposeBag()

let kenterBackgroundTimeLimit:Double =  30 * 60 // 5.0 // 30 * 60

/** 系统版本号 */
let ksystemVersion = (UIDevice.current.systemVersion as NSString).doubleValue
let kios7 = (ksystemVersion >= 7.0 && ksystemVersion < 8.0) ? true : false
let kios8:Bool = {
    return ksystemVersion >= 8.0 && ksystemVersion < 9.0
}()
let kios9 = (ksystemVersion >= 9.0) ? true : false


let kAppDelegate = kApplication.delegate as! AppDelegate

let kApplication = UIApplication.shared
/**由于PKHud弹出后，keywindow变成了PKHUD.Window ,故此处须找到相应的window，即第一此的window即可*/
let kwindow = UIApplication.shared.windows.first

let kwidth = UIScreen.main.bounds.width
let kheight = UIScreen.main.bounds.height
let kBounds = UIScreen.main.bounds

let kNotificationCenter = NotificationCenter.default
let kUserDefaults = UserDefaults.standard

let kbundle = Bundle.main
let kbundlePath = kbundle.resourcePath!

let khomeDirectory = NSHomeDirectory()
/// 外层temp目录
let ktempDirectory = NSTemporaryDirectory() // NSHomeDirectory + "/tmp"
/// 外层documents目录
let kdocumentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) // NSHomeDirectory() + "/Documents"
/// 外层library下的caches目录
let kcachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
/// 外层library下的preference目录.通过 NSUserDefaults 存储直接到此目录下
let kpreferencesDirectory = NSHomeDirectory() + "/Library/Preferences"


/**元*/
let kunitYuanText = " 元"
let kzeroYuanText = "0.00 元"


/**暂无*/
let knothing = "暂无"

/** 按钮的背景色 */
let kButtonBgColor = UIColor.RGBA(252, g: 116, b: 6, a: 1) // F85E0B
/** 按钮不能编辑时的颜色 */
let kButtonUnableBgColor = UIColor.RGBA(201, g: 201, b: 201, a: 1)
/** 分割线的背景色 */
let kSepLineBgColor = UIColor.RGBA(220, g: 220, b: 220, a: 1)
/** 提示语的常用背景色 */
let kSignTextColor = UIColor.RGBA(252, g: 116, b: 6, a: 1)
/** 导航控制器title */
let knavTitleColor = UIColor.RGBA(51, g: 51, b: 51, a: 1)
/** iconfot 的 fontSize */
let kfontSize = 20
/** 字的黑色 */
let kfontBlackColor = UIColor.colorWithHexString("333333")!

/** app挂起后，再次激活时的通知， 适用于在二维码扫描页面 */
let kBecomeActiveNotificate = "kBecomeActiveNotificate"

/** 常用Iconfont Text */
let kleftIconfont = "\u{e601}"
let krightIconfont = "\u{e600}"
//let kupIconfont = "\u{e604}"
let kdownIconfont = "\u{e610}"
/** 打钩框 */
let kcheckBoxSelect = "\u{e60f}"
let kcheckBoxUnSelect = "\u{e612}"



/** 列表勾 */
let kcheckInlist = "\u{e611}"

/** dian画 */
let kphoneIconfont = "\u{e615}"
/** 首页的 */
let kconsumeIconfont = "\u{e619}"
let korderIconfont = "\u{e614}"
let kscanQrIconfont = "\u{e616}"
/**登陆*/
let kloginAccountIconFont = "\u{e61a}"
let kloginPwdIconFont = "\u{e609}"

/** 主题橙色 */
let korangeColor = UIColor.colorWithHexString("FF7F50")!
/** 查看详情cell的背景色 */
let kdetailInfoCellBgColor = UIColor.RGBA(245, g: 245, b: 245, a: 1)
/** 所有非白色view的 背景色 */
let kviewBgColor = UIColor.RGBA(234, g: 234, b: 234, a: 1) // EAEAEA
/** 必填认证headcell的字体颜色 */
let ccHeadmCellTextColor = UIColor.RGBA(2, g: 149, b: 216, a: 1)
/** fei必填认证headcell的字体颜色 RGB(34,172,56)*/
let ccHeadCellTextColor = UIColor.colorWithHexString("22AC38")

let kfindNewVersion = "发现新版本"
let kupdatePathIsNil = "更新地址为空！"
let kcannotOpenUrl = "无法打开链接！"
let khaveNoAccessToContact = "夸时贷应用已禁止读取本地通讯录，您需要在权限设置中更改设置。"


/** 密码 提示 */
let kpwdLenghtLimit = 14
let kloginSuccess = "登录成功"
let kloginFailed = "登录失败"
let kphonePrompt = "请输入11位手机号！"
let kidCardPrompt = "请输入身份证号！"
let kverCodePrompt = "请输入验证码！"
let kpwdPrompt = "请输入6--14位密码！"
let kverPwdPrompt = "两次密码不匹配！"
let kpwdFormatFalse = "密码必须由6--14位数字和字母组成！"

let kuserNamePrompt = "请输入用户名！"
let kcheckBoxPrompt = "请勾选协议！"

let kisGiveUpEdit = "是否返回消费分期直达页？" // "确定退出当前申请吗？"
let kisGiveUpOpinionEdit = "编辑了那么久，确定放弃吗？"
let keditRelateInfoPrompt = "请填写所有信息，选填信息除外！"

let kpleaseSelect = "请选择"
let khaveNothingNow = "暂无"

let ksendCaptchaSuccess = "验证码发送成功！"
let ksaveBasicInfoSuccess = "保存基本信息成功！"
let ksaveProductInfoSuccess = "保存商品信息成功！"
let ksaveRelateInfoSuccess = "保存联系人信息成功！"
let ksavePayCardInfoSuccess = "保存还款卡信息成功！"
let ksetNewPwdSuccess = "设置新密码成功！"


let khud = PTHUD.shared


//-------------------------- key  ---------------------- //
/// 保存app唯一识别号的key
let ksaveAppUniqueIdentifykey = "appUniqueIdentify_key"
/// app的bundle id
let kappBundleIdkey = "CFBundleIdentifier"
/**当前app版本号,全部版本号 */
let kappVersionKey = "CFBundleShortVersionString"
/**大的版本号，build号*/
let kappBuildVersionKey = "CFBundleVersion"
/**用户登陆成功的用户名key， 因为退出时会清空用户信息，故须存储之以使用户名框自动有值*/
let ksaveUserNamekey = "loginUser_success_key"
/**保存app版本号, 次key加上了环境类型，不加版本号*/
let ksaveAppVersionkey = "appVersion_key" + ApiType
/**保存进入后台时的时间*/
let ksaveEnterBgDateKey = "lastEnterBackground_key"

/// 保存pdf的保存路径
let ksavePdfPathkey = ktempDirectory + "/测试pdf的11.pdf"

let ksaveFirstComeHomePageKey = "ksaveFirstComeHomePageKey_key" + ksaveAppVersionkey


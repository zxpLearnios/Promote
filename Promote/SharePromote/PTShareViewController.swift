//
//  PTShareViewController.swift
//  SharePromote
//
//  Created by Bavaria on 2018/4/28.
//  自定义分享界面

import Social
import UIKit

class PTShareViewController: UIViewController {
    
//    private lazy var spaceItem: SLComposeSheetConfigurationItem = {
//        let item = SLComposeSheetConfigurationItem()!
//        item.title = "空间"
//        item.value = "请选择"
//        item.tapHandler = {
//            self.spaceItemAction()
//        }
//        return item
//    }()
    
    private var extensionCtx = NSExtensionContext()
    private let lab = UILabel()
    private let imgV = UIImageView()
    private var backClosure: (() -> ())?
    
//    enum DocumentType: String {
//        case url = "public.url", fileUrl = "public.file", jpeg = "public.jpeg", png = "public.png", audio = "public.audio", video = "public.video", pdf = "public.pdf"
//    }
    
    private lazy var documentTypes: [String] = {
        return ["public.url", "public.jpeg", "public.png", "public.pdf", "public.file-url", "public.video"]
    }()
    // @noescape 是闭包的默认修饰
    convenience init(with extensionContext: NSExtensionContext, backClosure: (() -> Void)? = nil) {
        self.init()
        self.extensionCtx = extensionContext
        self.backClosure = backClosure
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSubviews()
        handleExtensionContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setSubviews() {
        view.addSubview(lab)
        view.addSubview(imgV)
        
        let backBtn = UIButton.init(frame: CGRect.init(x: 30, y: 100, width: 100, height: 40))
        backBtn.setTitle("<", for: .normal)
        backBtn.setTitleColor(.black, for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        view.addSubview(backBtn)
        
        lab.text = "--"
        lab.textAlignment = .center
        imgV.backgroundColor = .red
        lab.frame = CGRect(x: 10, y: 130, width: view.frame.width - 20, height: 20)
        imgV.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        imgV.center = view.center
    }
    
   
    /**
     *  获取分享的信息
     */
    private func handleExtensionContext() {
        for item in extensionCtx.inputItems {
            let inputItem = item as! NSExtensionItem
            
            for attachment in inputItem.attachments! {
                if let itemProvider = attachment as? NSItemProvider {
                    handle(itemProvider: itemProvider)
                }
            }
        }
    }
    
    
    /**
     * 处理item类型
     */
    private func handle(itemProvider: NSItemProvider) {
//        itemProvider.registeredTypeIdentifiers
       
//        let identifier = kUTTypeContent as String   // files attachment
//        let identifier2 = kUTTypeURL as String  // URL files
        
        
        if itemProvider.hasItemConformingToTypeIdentifier("public.url") { // // public.url
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { [weak self] secureCodeing, _ in
                let obj = secureCodeing as AnyObject
                if obj.classForCoder == URL.self || obj.classForCoder == NSURL.self {
                    let url = obj as! URL
                    self?.lab.text = url.absoluteString
                }
                
            })
        } else if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") || itemProvider.hasItemConformingToTypeIdentifier("public.png") {
            itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil, completionHandler: { [weak self] secureCodeing, _ in
                let obj = secureCodeing as AnyObject
                if obj.classForCoder == URL.self || obj.classForCoder == NSURL.self {
                    let url = obj as! URL
                    var path = url.absoluteString
                    if path.hasPrefix("file://") {
                        let startIndex = path.startIndex
                        let endIndex =  path.index(path.startIndex, offsetBy: 7, limitedBy: path.endIndex)!
                        path.replaceSubrange(Range(startIndex ..< endIndex), with: "")
                        let img = UIImage.init(contentsOfFile: path)
                        self?.imgV.image = img
                    }
                    
                }
                
            })
        }
    
    }
    
    @objc private func backAction() {
        back()
        if let callback = backClosure {
            callback()
        }
    }
    
    private func back() {
//        if navigationController != nil {
//            navigationController?.popViewController(animated: true)
//        } else {
//            dismiss(animated: true, completion: nil)
//        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

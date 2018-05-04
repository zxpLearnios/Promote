//
//  PTPreViewController.swift
//  Promote
//
//  Created by Bavaria on 2018/5/3.
//  本地文件查看, 文件必须下载到本地
//  如果需要自定义页面上面有其他控件的话，可以将之加为子控制器使用即可

import UIKit
import QuickLook

class PTFilePreviewController: QLPreviewController {

    
    var filePaths = [String]() {
        didSet {
            reloadData()
        }
    }
    
    // MARK： 传入文件名
    convenience init(with fileNames: [String] = []) {
        self.init(nibName: nil, bundle: nil)
        handleFilePaths(fileNames)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if let nav = navigationController {
//            nav.toolbar.isHidden = true
        }
    }

    
    func handleFilePaths(_ filePaths: [String]) {
        if filePaths.count == 0 {
            return
        }
        self.filePaths = filePaths
    }

    
    
    
}


extension PTFilePreviewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return filePaths.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let fileName = filePaths[index]
        var filePath = ""
        if index == filePaths.count - 1 {
            filePath = PTBaseBundle.loadFile(name: fileName)
        } else {
            filePath = PTBaseBundle.loadImage(name: fileName)
        }
        
        var url: URL
        if String.isUrlStr(filePath) {
            url = URL.init(string: filePath)!
        } else {
            url = URL.init(fileURLWithPath: filePath, relativeTo: nil)
        }
        
        return url as QLPreviewItem
    }
    
    
    
}


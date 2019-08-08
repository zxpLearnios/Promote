//
//  PTFileOperatorManager.swift
//
//  Created by 张净南 on 2018/8/31.
//  Copyright © 2018年 Bavaria. All rights reserved.
//

import UIKit

class PTFileOperatorManager: NSObject {
    
    /// 获取沙盒中某种文件的路径和名字，存入字典返回
    static func getFilenamelistOfType(_ type: String, dirPath: String) {
        
        var filenamelist = [String]()
        
        do {
            let tmplist = try? FileManager.default.contentsOfDirectory(atPath: dirPath)
            var fileDic = [String: Any]()
            guard tmplist != nil else {
                return
            }
            for filename in tmplist! {
                let fullpath = dirPath.appending(filename)
                
                if isFileExistAtPath(fullpath) {
//                    filename
                    
//                    if ([[filename pathExtension] isEqualToString:type]) {
//                        fileDic[@"fileName"] = filename;
//                        fileDic[@"filePath"] = fullpath;
//                        [filenamelist  addObject:fileDic];
//                    }
                }
                
            }
           
        } catch {
            
        }
    }
    
    // MARK: 判断文件路径是否存在
    static func isFileExistAtPath(_ fileFullPath: String) -> Bool {
        let fm = FileManager.default
        var isExist = fm.fileExists(atPath: fileFullPath)
        return isExist
    }
    
    
    // MARK: 浅度遍历：根据目录路径获取该目录下所有文件夹
    static func getAllFolderWithTheSpecifiedDirectory(_ directory: String) {
        let fm = FileManager.default
        do {
            let fileArr = try
                fm.contentsOfDirectory(atPath: directory)
            try fm.removeItem(atPath: directory + "/Snapshots")
            debugPrint("浅度遍历：\(directory)：共有\(fileArr.count)个文件和文件夹, 为： \(fileArr.debugDescription)")
        } catch let err {
            debugPrint("浅度遍历出错！")
        }
    }
    
    // MARK: 深度遍历：根据目录路径获取该目录下所有文件夹和文件
    static func getAllFolderAndFileWithTheSpecifiedDirectory(_ directory: String) {
        let fm = FileManager.default
        do {
            let fileArr = try
                fm.subpathsOfDirectory(atPath: directory)
            debugPrint("深度遍历：共有\(fileArr.count)个文件和文件夹, 为： \(fileArr.debugDescription)")
        } catch let err {
        }
        
    }
    

}

//
//  PTBaseChatViewController.swift
//  Promote
//
//  Created by bavaria on 2018/5/18.
//  聊天
// 1. cell最好的使用方式就是，控制器一开始就注册cell，占用内存少，性能也好。

import UIKit
import Cartography


class PTBaseChatViewController: UIViewController {

    var tableView: PTBaseTableView!
    var cellId = "PTBaseChatCell"
    let inputTextView = PTBaseChatInputView()
    
    var models: [PTChatActorModel] = {
        var ary = [PTChatActorModel]()
        var content = "发送的内容"
        for i in 0...24 {
            let model = PTChatActorModel()
            model.isSendByMe = (i % 2 == 0)
//            model.msgSendDate
            model.msgContent = "第\(i)次" + content
            content += "开始-----发送的内容=="
            model.msgSendDate = "11-12-10 11:11:\(i)"
            ary.append(model)
        }
        return ary
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        registeCell()
        
        
    }

    private func setupSubViews() {
        tableView = PTBaseTableView()
        view.addSubview(tableView)
        
        constrain(tableView) { (tv) in
            let sv = tv.superview!
            tv.top == self.safeAreaTop
            tv.bottom == sv.bottom
            tv.left == sv.left
            tv.right == sv.right
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40 + 10 + 10
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        // 输入框
        inputTextView.backgroundColor = .gray
        addSubview(inputTextView)
        constrain(inputTextView) { (input) in
            let sv = input.superview!
            input.width == sv.width
            input.height == 80
            input.bottom == sv.bottom
        }
        
        inputTextView.frameChangeClosure = {[weak self] isMoveUp, ty, duration in
            if let `self` = self {
                if self.models.count == 0 {
                    return
                }
                let index = IndexPath.init(row: self.models.count - 1, section: 0)
                
                if isMoveUp {
                    // 键盘弹出时，列表滚动至（最后一行）最底部
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: false)
                    self.tableView.transform = CGAffineTransform(translationX: 0, y: ty)
                } else {
                     self.tableView.transform = CGAffineTransform.identity
                }

            }
            
        }
    }
    
    func registeCell() {
        tableView.register(PTBaseChatCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}

extension PTBaseChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 说是系统推荐用此种写法
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? PTBaseChatCell
//        if cell == nil {
//            cell = PTBaseChatCell.init(style: .default, reuseIdentifier: cellId)
//        }
//        let row = indexPath.row
//        let model = models[safe: row]
//        cell!.fillData(chatActorModel: model)
//
//        return cell!
        
        // 测试发现上面的写法和下面的(一开始就注册cell)一样，都是会在一开始的时候就立即调10几次 cell里的override init(style: UITableViewCellStyle, reuseIdentifier: String?)方法。之后，就不会再调了
        
        // 此法，还比上面的性能高一点（占用内存少一点）
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PTBaseChatCell
        let row = indexPath.row
        let model = models[safe: row]
        cell.fillData(chatActorModel: model)

        return cell
    }
    
}

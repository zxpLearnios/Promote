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
    
    var testAgainMsg = "最新内容"
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
        
        let customeRightItem = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        customeRightItem.setTitle("加载更多", for: .normal)
        customeRightItem.setTitleColor(.black, for: .normal)
        customeRightItem.addTarget(self, action: #selector(reloadMore), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customeRightItem)
        
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        // 输入框
        addSubview(inputTextView)
        constrain(inputTextView) { (input) in
            let sv = input.superview!
            input.width == sv.width
            input.height == 80
            input.bottom == sv.bottom
        }
        
        inputTextView.frameChangeClosure = {[weak self] isMoveUp, ty, duration in
            if let `self` = self {
                if self.isEmptyList() {
                    return
                }
                
                if isMoveUp {
                    // 键盘弹出时，列表滚动至（最后一行）最底部
                    self.tableViewScrollToLastRow()
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
    
    
    
    @objc func reloadMore() {
        let model = PTChatActorModel()
        model.isSendByMe = true
        testAgainMsg += testAgainMsg
        model.msgContent = testAgainMsg
        models.append(model)
        
        tableView.reloadData()
        
        tableViewScrollToLastRow()
    }
    
    private func isEmptyList() -> Bool {
        return models.count == 0
    }
    
    private func deSelectAllRow() {
        
        //        tableView.deselectRow(at: <#T##IndexPath#>, animated: <#T##Bool#>)
    }
    
    private func tableViewScrollToLastRow() {
        if isEmptyList() {
            return
        }
        let lastRow = IndexPath.init(row: models.count - 1, section: 0)
        self.tableView.scrollToRow(at: lastRow, at: .bottom, animated: false)
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


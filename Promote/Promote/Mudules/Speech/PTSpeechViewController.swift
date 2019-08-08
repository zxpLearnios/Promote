//
//  PTSpeechViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/10/29.
//  语音朗读，朗读一段文字

import UIKit
import SnapKit

class PTSpeechViewController: UIViewController {

    let textView = UITextView()
    let startBtn = PTTapLabel()
    let pauseBtn = PTTapLabel()
    let continueBtn = PTTapLabel()
    let stopBtn = PTTapLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTextView()
    }
    
    func setup() {
        addSubview(textView)
        addSubview(startBtn)
        addSubview(pauseBtn)
        addSubview(continueBtn)
        addSubview(stopBtn)
        startBtn.text = "开始"
        pauseBtn.text = "暂停"
        continueBtn.text = "继续"
        stopBtn.text = "停止"
        
        textView.backgroundColor = .lightGray
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        startBtn.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(textView.snp.bottom).offset(20)
        }
        pauseBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.top.equalTo(startBtn)
        }
        continueBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pauseBtn.snp.bottom).offset(30)
        }
        stopBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(continueBtn)
            make.top.equalTo(continueBtn.snp.bottom).offset(30)
        }
        
        startBtn.tapClosure = {_,_ in
            PTSpeechManager.shared.read(with: self.textView.attributedText.string)
        }
        pauseBtn.tapClosure = {_,_ in
            PTSpeechManager.shared.pauseRead()
        }
        continueBtn.tapClosure = {_,_ in
            PTSpeechManager.shared.continueRead()
        }
        stopBtn.tapClosure = {_,_ in
            PTSpeechManager.shared.stopRead()
        }
    }
    
    func setupTextView() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        
        let str = "\t作者：苏轼\n" +
            "\t大江东去，浪淘尽，千古风流人物。\n故垒西边，人道是，三国周郎赤壁。\n乱石穿空，惊涛拍岸，卷起千堆雪。\n江山如画，一时多少豪杰。\n" +
        "\t遥想公瑾当年，小乔初嫁了，雄姿英发。\n羽扇纶巾，谈笑间，樯橹灰飞烟灭。\n故国神游，多情应笑我，早生华发。\n"
        
        textView.attributedText = NSAttributedString.init(string: str, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.paragraphStyle: paragraph])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PTSpeechManager.shared.stopRead()
        
        
    }

}

//
//  PTVoiceRecognizeViewController.swift
//  Promote
//
//  Created by 张净南 on 2018/10/30.
//  语音识别

import UIKit
import SnapKit

class PTVoiceRecognizeViewController: UIViewController {

    let hintLab = PTBaseLabel(with: .red, fontSize: 20)
    let voiceContentLab = PTBaseLabel()
    let startLab = PTTapLabel(with: .gray, fontSize: 20)
    let stopLab = PTTapLabel(with: .gray, fontSize: 20)
    
    let voiceRecognizer = PTVoiceRecognizeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview(hintLab)
        addSubview(voiceContentLab)
        addSubview(startLab)
        addSubview(stopLab)
        
        startLab.text = "开始录音"
        stopLab.text = "结束录音"
        hintLab.text = "识别到的语音内容为："
        voiceContentLab.numberOfLines = 0
        startLab.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.left.equalTo(30)
        }
        stopLab.snp.makeConstraints { (make) in
            make.top.equalTo(startLab)
            make.left.equalTo(startLab.snp.right).offset(20)
        }
        hintLab.snp.makeConstraints { (make) in
            make.top.equalTo(startLab.snp.bottom).offset(20)
            make.left.equalTo(20)
        }
        voiceContentLab.snp.makeConstraints { (make) in
            make.top.equalTo(hintLab.snp.bottom)
            make.left.equalTo(hintLab)
        }
        
        startLab.tapClosure = {_,_ in
            self.voiceRecognizer.startVoiceRecognize(closure: { (result, isfinish) in
                self.voiceContentLab.text = result
            })
        }
        stopLab.tapClosure = {_,_ in
            self.voiceRecognizer.stopRecord()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

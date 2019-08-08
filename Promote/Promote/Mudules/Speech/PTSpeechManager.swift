//
//  PTSpeechManager.swift
//  Promote
//
//  Created by 张净南 on 2018/10/29.
//  语音朗读、识别

import UIKit
import AVFoundation

class PTSpeechManager {

    static let obj = PTSpeechManager()
    class var shared: PTSpeechManager {
        return obj
    }
    
    let speechSyn = AVSpeechSynthesizer()
    
    func read(with string: String) {
        let speechString = string
        let speechUtt = AVSpeechUtterance(string: speechString)
        // 语速
        speechUtt.rate = AVSpeechUtteranceDefaultSpeechRate
        // 音高,[0.5 - 2] 默认 = 1
        //AVSpeechUtteranceMaximumSpeechRate
        //AVSpeechUtteranceMinimumSpeechRate
        //AVSpeechUtteranceDefaultSpeechRate
        speechUtt.pitchMultiplier = AVSpeechUtteranceDefaultSpeechRate
        // 音量,[0-1] 默认 = 1
        speechUtt.volume = 1
        
        // 读一段前的停顿时间
//        speechUtt.preUtteranceDelay = 1
        // 读完一段后的停顿时间
        speechUtt.postUtteranceDelay = 3
        
        let speechVoice = AVSpeechSynthesisVoice(language: "zh_CN") // language identifier
        speechUtt.voice = speechVoice
        // 开始朗读
        speechSyn.speak(speechUtt)
    }
    
    func pauseRead() {
        if speechSyn.isSpeaking {
            speechSyn.pauseSpeaking(at: .immediate)
        }
    }
    
    func continueRead() {
        if speechSyn.isSpeaking {
            return
        }
        speechSyn.continueSpeaking()
    }
    
    func stopRead() {
        if speechSyn.isSpeaking {
            speechSyn.stopSpeaking(at: .immediate)
        }
    }
    
}





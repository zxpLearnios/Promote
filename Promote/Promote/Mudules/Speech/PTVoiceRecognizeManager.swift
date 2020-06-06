//
//  PTVoiceRecognizeManger.swift
//  Promote
//
//  Created by 张净南 on 2018/10/30.
//  语音识别, 须真机

import UIKit
import Speech
import AVFoundation


class PTVoiceRecognizeManager: NSObject {

    let voiceRecognizer: SFSpeechRecognizer? = {
        let local = Locale.init(identifier: "zh_CN")
        let localRecognizer = SFSpeechRecognizer(locale: local)
        return localRecognizer
    }()
    
    let audioEngine = AVAudioEngine()
    var voiceRecognizeTask: SFSpeechRecognitionTask!
    // 不能被重用，故每次都需要初始化
    var audioRecognitionRequest:  SFSpeechAudioBufferRecognitionRequest!
    
    
    func isHaveAccessToVoiceRecognizer(closure: @escaping ((String,  Bool?) -> ())) {
        SFSpeechRecognizer.requestAuthorization { (status) in
            var statusStr = ""
            var statusBl: Bool?
            
            switch status {
            case .notDetermined:
                statusStr = "语音识别授权状态未知"
            case .denied:
                statusStr = "拒绝语音识别"
                statusBl = false
            case .restricted:
                statusStr = "语音识别在此设备上受限"
                statusBl = false
            case .authorized:
                statusStr = "授权语音识别"
                statusBl = true
            }
            closure(statusStr, statusBl)
        }
    }
    
    
    
//    func startRecord() {
//
//    }
    
    func stopRecord() {
        audioEngine.stop()
        audioRecognitionRequest.endAudio()
        if voiceRecognizeTask != nil {
            voiceRecognizeTask.cancel()
        }
    }
    
    // MARK: 开始语音识别， 识别内容、是否结束、
    func startVoiceRecognize(_ voice: String? = nil, closure: @escaping ((String?, Bool) -> ())) {
        
        func entityFunc() {
            
            stopRecord()
            
            if let voiceFile = voice, voiceFile.count != 0  {
                let local = Locale.init(identifier: "zh_CN")
                let localRecognizer = SFSpeechRecognizer(locale: local)
                if let voiceUrl = Bundle.main.url(forResource: voiceFile, withExtension: nil) {
                    let surRequest = SFSpeechURLRecognitionRequest(url: voiceUrl)
                    localRecognizer?.recognitionTask(with: surRequest, resultHandler: { (result, err) in
                        if err != nil {
                            PTPrint("语音识别解析失败")
                            closure(nil, true)
                            return
                        }
                        // 识别出的语音内容
                        let voiceRecognizeContent =  result?.bestTranscription.formattedString
                        closure(voiceRecognizeContent, true)
                    })
                } else {
                    PTPrint("本地语音文件未找到")
                    closure(nil, true)
                }
                
            } else { // 识别语音
                
                if voiceRecognizeTask != nil {
                    voiceRecognizeTask.cancel()
                }
                
                audioRecognitionRequest =  SFSpeechAudioBufferRecognitionRequest()
                
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    try audioSession.setCategory(AVAudioSession.Category.record)
                    try audioSession.setMode(AVAudioSession.Mode.measurement)
//                    try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                } catch let err {
                    PTPrint("audioSession 在set时出现错误\(err.localizedDescription)")
                }
                
                let inputNode = self.audioEngine.inputNode
                audioRecognitionRequest.shouldReportPartialResults = true
                
                // 开始录音、结束录音都出触发此回调，结束时err!=nil，为216 (The operation couldn’t be completed. (kAFAssistantErrorDomain error 216.)
                voiceRecognizeTask = voiceRecognizer?.recognitionTask(with: audioRecognitionRequest, resultHandler: { (result, err) in
//                    guard let `self` = self else {
//                        return
//                    }
                    var isfinal = false
                    if err != nil {
                        self.audioEngine.stop()
                        inputNode.removeTap(onBus: 0)
                        closure("", true)
                    }
                    
                    if let voiceRecognizeResult = result {
                        // 识别出的语音内容
                        let voiceRecognizeContent =  voiceRecognizeResult.bestTranscription.formattedString
                        isfinal = voiceRecognizeResult.isFinal
                        if isfinal {
                            self.audioEngine.stop()
                            inputNode.removeTap(onBus: 0)
                        }
                        
                         closure(voiceRecognizeContent, true)
                    }
                    
                })
                
                let recordingFormat = inputNode.outputFormat(forBus: 0)
                // 在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
                inputNode.removeTap(onBus: 0)
                inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                    self.audioRecognitionRequest.append(buffer)
                }
                audioEngine.prepare()
                do {
                    try audioEngine.start()
                } catch {
                    
                }
            }
        }
        
        isHaveAccessToVoiceRecognizer { (_, result) in
            if let result = result {
                if result {
//                    entityFunc()
                }
            }
        }
        
        
    }
    
    
    
}




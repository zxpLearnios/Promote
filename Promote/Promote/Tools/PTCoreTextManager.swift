//
//  PTCoreTextManager.swift
//  Promote
//
//  Created by 张净南 on 2018/8/1.
//  coreText的使用  数据多时，需要注意先后顺序问题，及需要同步、异步处理
//  1. 所有的CTLineGetStringIndexForPosition获取的index都是错误的，因为每次获取的值都是会变化的

import UIKit
import Foundation
import CoreText

class PTCoreTextManager: UIView {
    
    /// 保存已经绘制的图片frame。在drawRect里转换坐标系后，好像坐标系起点还是在self的左下角，x：水平👉正  y:竖直👆正，但必须在drawRect里转换坐标系以使绘制没问题，但点击时需要转换frame
    private(set) var imageFrameArray = [CGRect]()
    private(set) var drawframe: CTFrame!
    /// 需要处理的 普通字符范围 数组，即一段一段的字符串组成的数组, start end
    private var normalStringRanges = [[NSRange]]()
    /// 需要处理的 链接字符范围 数组，即一段一段的字符串组成的数组
    private var linkStringRanges = [[NSRange]]() // [[(Int, Int)]]()
    
    private var mainAttributeStr: NSMutableAttributedString!
    
    convenience init(with view: UIView) {
        self.init(frame: .zero)
        view.addSubview(self)
        self.backgroundColor = .white
        self.frame = CGRect(x: 100, y: 120, width: 200, height: 200)
        addGestureRecognize()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        draw()
    }
    
    func draw() {
        guard drawframe == nil else {
            return
        }
        if let ctx = UIGraphicsGetCurrentContext() {
            
            // 字形的变换矩阵为不做图形变换
            ctx.textMatrix = .identity
            // 调整坐标系
            ctx.translateBy(x: 0, y: self.height)
            ctx.scaleBy(x: 1, y: -1)
            
            mainAttributeStr = NSMutableAttributedString(string: "滚滚长江东逝水逝水")
            
            // underlineStyle:下划线 strikethroughStyle:中划线
            // 段落样式
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byCharWrapping
            let paragraphDic = [NSAttributedStringKey.paragraphStyle: paragraphStyle]
            
            let mainAttributeDic: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 26), NSAttributedStringKey.foregroundColor: UIColor.red]
            let numberAttributeDic = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20), NSAttributedStringKey.foregroundColor: UIColor.lightGray]
            // baselineOffset
            let linkAttributeDic: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor: UIColor.blue, NSAttributedStringKey.strikethroughStyle: NSNumber(value: 3)]
            
            // 其他内容字符
            mainAttributeStr.addAttributes(mainAttributeDic, range: NSRange.init(location: 0, length: mainAttributeStr.length))
            let numberAttributeStr = NSAttributedString(string: "123456", attributes: numberAttributeDic)
            let linkAttributeStr = NSAttributedString(string: "http://www.baidu.com", attributes: linkAttributeDic)
            
            // 拼接富文本
            mainAttributeStr.append(numberAttributeStr)
            
            // 在适当的位置插入图片
            setupPlaceholderImage(with: mainAttributeStr, identify: "placeholder_one", index: 1)
            setupPlaceholderImage(with: mainAttributeStr, identify: "placeholder_two", index: 6)
            
            // 保存链接字符串的range
            let beforeAppendLinkLength = mainAttributeStr.length
            // 添加link 设置段落
            mainAttributeStr.append(linkAttributeStr)
            mainAttributeStr.addAttributes(paragraphDic, range: NSRange(location: 0, length: mainAttributeStr.length))
            
            let linkAttributeStrRange = NSRange(location: beforeAppendLinkLength, length: linkAttributeStr.length) // (beforeAppendLinkLength,  beforeAppendLinkLength + linkAttributeStr.length)
            let linkAttributeStrRangeAry = [linkAttributeStrRange]
            linkStringRanges.append(linkAttributeStrRangeAry)
            
            // 绘制文本
            let length = mainAttributeStr.length
            let frameSetter = CTFramesetterCreateWithAttributedString(mainAttributeStr)
            
            let path = CGMutablePath()
            // 字体区域的左边、头部间距
            let fontRectX: CGFloat = 15
            let fontRectY: CGFloat = 15
            // 绘制区域必须这样设置
            let fontBounds = CGRect(x: 0, y: fontRectY, width: width - fontRectX , height: height - fontRectY)
            // 字体超出view边界会被挡住，这里最好不要偏移,需要的化，设置段落
            let fontRect = fontBounds.offsetBy(dx: fontRectX, dy: -fontRectY)
            path.addRect(bounds)
            
            drawframe = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, nil)
            CTFrameDraw(drawframe, ctx)
            
            // 提前计算所有需要绘制的图片的rect
            calculatePlaceholderImageRect(with: drawframe, ctx: ctx)
            
            guard imageFrameArray.count != 0 else {
                return
            }
            // 绘制所有图片
            let images = [#imageLiteral(resourceName: "base_chat_input_audio"), #imageLiteral(resourceName: "base_chat_input_emoji")]
            for i in 0..<imageFrameArray.count {
                let imageFrame = imageFrameArray[i]
                let cgImage = images[i].cgImage!
                ctx.draw(cgImage, in: imageFrame)
            }
            
        }
    }
    
    func addGestureRecognize() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    // MARK: 点击事件
    @objc func tapAction(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        let i = getIndexOfTapInImage(with: point)
//        PTPrint("点击了第\(i)个图片")
        if i == -1 {
            _ = getIndexOfTapInString(with: point)
        }
    }
    
    // MARK: 数组占位图片的代理 插入的位置
    func setupPlaceholderImage(with attributeString: NSMutableAttributedString,  identify: String, index: Int) {
//        var sizeDic: [String: CGFloat] = ["width": 50, "height": 50]
//        var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: deallocFunc, getAscent: ascentFunc, getDescent: descentFunc, getWidth: widthFunc)
        // 里面的ref就是CTRunDelegateCreate(&callbacks, &tag)里的tag
        var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: {ref in
            PTPrint("RunDelegate deinit")
        }, getAscent: {ref in
            return 50
        }, getDescent: {ref in
            return 0
        }, getWidth: {ref in
            return 50
        })

        // swift3  获取size：MemoryLayout<Class>.size, MemoryLayout.size(ofValue: object)
//        memset(&callbacks, 0, MemoryLayout.size(ofValue: callbacks)) // MemoryLayout<CTRunDelegateCallbacks>.size
        var tag = identify
        let delegate = CTRunDelegateCreate(&callbacks, &tag)
        
        // 占位文字代理
        // CTRunDelegateCreate(&callbacks1, &placeholderTwoDic)
        let attributeDic: [NSAttributedStringKey: Any] = [NSAttributedStringKey.init(kCTRunDelegateAttributeName as String): delegate, NSAttributedStringKey(tag): tag]
        
        // 插入占位符
        var char: UniChar = 0xFFFC
        let placeholder = NSString(characters: &char, length: 1) as String
        let placeholderAttributeStr = NSMutableAttributedString(string: placeholder) // placeholder " "
        
        placeholderAttributeStr.addAttributes(attributeDic, range: NSRange(location: 0, length: 1))
        
        attributeString.insert(placeholderAttributeStr, at: index)
    }
    
    // MARK: 计算所有需要绘制的图片布局，将布局信息存入imageFrameArray
    func calculatePlaceholderImageRect(with frame: CTFrame, ctx: CGContext? = nil) {
        
        // 获取CTFrame下的总行数
        let lines = CTFrameGetLines(frame)
        let lineCount = CFArrayGetCount(lines)
        
        // 存放绘制区域的
        var points = [CGPoint].init(repeating: .zero, count: lineCount)
        // 获取所有CTLine的原点
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &points)
        
        for i in 0..<lineCount {
            // 获取具体的每行
            let line = (lines as Array)[i] as! CTLine
            // 每行的字形总流量
            let lineGlyphRuns = CTLineGetGlyphRuns(line)
            
            var lineAscent: CGFloat = 0
            var lineDescent: CGFloat = 0
            var lineleading: CGFloat = 0
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineleading)
            
            let lineGlyphRunsCount = CFArrayGetCount(lineGlyphRuns)
            // 每行的总字数 CTLineGetGlyphCount  CTLineGetStringIndexForPosition
//            PTPrint("绘制第\(CTLineGetStringRange(line))行")
            
            for j in 0..<lineGlyphRunsCount {
                
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var runBounds: CGRect
                
                // 每行的具体的那个run
                let lineGlyphRun = (lineGlyphRuns as Array)[j] as! CTRun
               
                // 每行的具体的那个run的夙愿设置属性的键值对
                let lineGlyphRunDic = CTRunGetAttributes(lineGlyphRun) as NSDictionary
                if let delegate = lineGlyphRunDic[kCTRunDelegateAttributeName] {
                    // 根据代理
                    let runConfig = CTRunDelegateGetRefCon(delegate as! CTRunDelegate)
                    let configDicPointer = runConfig.assumingMemoryBound(to: NSDictionary.self)
//                    let configDic = configDicPointer.pointee
//                    if configDic.allKeys.count == 0 {
//                        continue
//                    }
                    
                    // 计算绘制区域
                    let point = points[i]
                    
                    let width = CTRunGetTypographicBounds(lineGlyphRun, CFRangeMake(0, 0), &ascent, &descent, nil)
                    let height = ascent + descent
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lineGlyphRun).location, nil)
                    
                    let x = point.x + xOffset
                    let y = point.y - descent
                    
                    runBounds = CGRect(x: x, y: y, width: CGFloat(width), height: height)
                    
                    // 路径
                    let path = CTFrameGetPath(frame)
                    let boxRectOfPath = path.boundingBoxOfPath
                    let imageRect = runBounds.offsetBy(dx: boxRectOfPath.origin.x, dy: boxRectOfPath.origin.y)
                    // 保存需要绘制的图片的rect
                    if imageFrameArray.count == 0 {
                        imageFrameArray.append(imageRect)
                    } else {
                        if let _ = imageFrameArray.index(of: imageRect) { // 已经绘制过，及一个位置只会绘制一个图片
                            continue
                        } else {
                            imageFrameArray.append(imageRect)
                        }
                    }
                } else { // 代理不存在
                }
                
            }
            
        }
    }
    
    // MARK: 点击了第几个图片 -1：未点击到图片
    func getIndexOfTapInImage(with point: CGPoint) -> Int {
        
        guard imageFrameArray.count != 0 else {
            return -1
        }
        for i in 0..<imageFrameArray.count {
            // 这个frame的坐标系起点在self的左下角，x：水平👉正  y:竖直👆正
            let imgFrame = imageFrameArray[i]
            // 转换坐标 得到正确的frame，即从右上角开始
            let normalFrame = CGRect(x: imgFrame.origin.x, y: height - imgFrame.origin.y - 50, width: imgFrame.width, height: imgFrame.height)
            
            let result = normalFrame.contains(point)
            if i == imageFrameArray.count - 1 {
                return result ? i : -1
            } else {
                if !result { // 继续便利图片数组
                    continue
                }
                return i
            }
        }
        return -1
    }
    
    // MARK: 获取点击了哪行的哪个字符，除图片外
    func getIndexOfTapInString(with point: CGPoint) -> Int {
        guard drawframe != nil else {
            return -1
        }
        
        // 获取CTFrame下的总行数
        let lines = CTFrameGetLines(drawframe)
        let lineCount = CFArrayGetCount(lines)
        
        // 存放绘制区域的
        var linePoints = [CGPoint].init(repeating: .zero, count: lineCount)
        // 获取所有CTLine的原点 每行的起点
        CTFrameGetLineOrigins(drawframe, CFRangeMake(0, 0), &linePoints)
        
        for i in 0..<lineCount {
            // 获取具体的每行
//            let line = (lines as Array)[i] as! CTLine
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)
            
            // 字体流数组： 每行有几种类型的字体流，如第一行为：aAa，则第一行有3中类型的字体流
            let lineGlyphRuns = CTLineGetGlyphRuns(line)
            // 每行的起点
            let linePoint = linePoints[i]
            // 每行总的字体流
            let lineGlyphRunsCount = CFArrayGetCount(lineGlyphRuns)
//            let linepoint = CFArrayGetValueAtIndex(lines, 0)
            
            
            var lineAscent: CGFloat = 0
            var lineDescent: CGFloat = 0
            var lineLeading: CGFloat = 0
            var lineBounds: CGRect
            let lineWidth = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading)
            let lineHeight = lineAscent + lineDescent // + lineLeading

            // 当每行里都大小不同的字体时，此法获取的行rect没有实际意义，而每行的run的rect是自由意义的
            let lineRect = CGRect(x: linePoint.x, y: linePoint.y, width: CGFloat(lineWidth), height: lineHeight)

            let newRect = CGRect(x: lineRect.origin.x, y: self.height - lineRect.origin.y - 26, width: lineRect.width, height: lineRect.height)
            // 所有CTLineGetStringIndexForPosition获取的index都是错误的，因为此值会变化，如： 第一次获取的为a之后获取的为a+--1
//            if newRect.contains(point) {
//                let newPoint = CGPoint(x: point.x - newRect.minX, y: point.y - newRect.minY)
//                let indexInParagraph = CTLineGetStringIndexForPosition(line, newPoint)
////                PTPrint("第\(i)行，全段的第\(indexInParagraph)个字符")
//            }
            
            for j in 0..<lineGlyphRunsCount {
                
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var runBounds: CGRect
                
                // 每行的具体的某个run, 每个run绘制一段字体流
                let lineGlyphRun = (lineGlyphRuns as Array)[j] as! CTRun
                
                let runWidth = CTRunGetTypographicBounds(lineGlyphRun, CFRangeMake(0, 0), &ascent, &descent, nil)
                let runHeight = ascent + descent
                let runOffsetX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lineGlyphRun).location, nil)
                
                let runX = linePoint.x + runOffsetX
                let runY = linePoint.y - descent
                
                // 每行具体的某段字体的rect 转换了坐标
                runBounds = CGRect(x: runX, y: self.height - runHeight - runY, width: CGFloat(runWidth), height: runHeight)
//                PTPrint("字体流：\(runBounds.debugDescription)")
                
//                let lineRange = CTLineGetStringRange(line)
                // 每个run的开始
                let ctRunRange = CTRunGetStringRange(lineGlyphRun)
                let ctRunStartIndex = ctRunRange.location
                let ctRunLength = ctRunRange.length
                
                if runBounds.contains(point) {
                    
                    // 汉字是可以的，英文就不准确了
//                    let runGlyphDic = CTRunGetAttributes(lineGlyphRun) as NSDictionary
//                    let offSetX = point.x - runBounds.origin.x
//
//                    if let runFont = runGlyphDic["NSFont"] as? UIFont {
//                        let fontSize = runFont.pointSize
//                        let index = Int(offSetX / fontSize)
//                        PTPrint("11111 \(index)")
//                    }

                    // 每行的run的具体的内容attribute
                    let runRange = NSRange(location: ctRunStartIndex, length: ctRunLength)
                    // run对应的attributeStr
                    let attributeStr = mainAttributeStr.attributedSubstring(from: runRange)
                    let sublinkStringRange = [NSRange](repeating: runRange, count: 1)
                    let isRunRangeInLinkRanges = linkStringRanges.contains(sublinkStringRange)
                    
                    khud.showPromptText("点击了run，内容为：\(attributeStr.string)")
                }
            }
            
        }
       
        return 0
    }
    
}

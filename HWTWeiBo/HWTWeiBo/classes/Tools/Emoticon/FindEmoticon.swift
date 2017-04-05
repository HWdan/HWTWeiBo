//
//  FindEmoticon.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2017/1/9.
//  Copyright © 2017年 AAS. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    //MARK: - 单例
    static let shareIntance: FindEmoticon = FindEmoticon()
    
    //MARK: - 表情属性
    private lazy var manager: EmoticonManager = EmoticonManager()
    
    //MARK: - 查找属性字符串的方法
    func findAttrString(statusText: String?, font: UIFont) -> NSMutableAttributedString? {
        //如果 statusText 没有值，则直接返回nil
        guard let statusText = statusText else {
            return nil
        }
        //创建匹配规则(匹配表情)
        let pattern = "\\[.*?\\]"
        //创建正则表达式对象
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        //开始匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.characters.count))
        //获取结果
        let attrMStr = NSMutableAttributedString(string: statusText)
        for (_,result) in results.enumerated().reversed() {
            //获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            //根据chs，获取图片的路径
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }
            //创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
            
        }
        return attrMStr
    }
    ///查找表情 png 图片路径
    private func findPngPath(chs: String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }

}

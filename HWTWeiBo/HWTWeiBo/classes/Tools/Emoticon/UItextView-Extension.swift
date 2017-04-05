//
//  UItextView-Extension.swift
//  表情键盘demo
//
//  Created by hegaokun on 2017/1/6.
//  Copyright © 2017年 AAS. All rights reserved.
//

import UIKit

extension UITextView {
    
    func getEmoticonString() -> String {
        //获取属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        //遍历属性字符串
        let range = NSMakeRange(0, attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMStr.string
    }
    
    func insertEmoticon(emoticon: Emoticon) {
        //空白表情
        if emoticon.isEmpty {
            return
        }
        //删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        //emoji 表情
        if emoticon.emojiCode != nil {
            //获取光标所在的位置： UITextRange
            let textRange = selectedTextRange!
            //替换 emoji 表情
            replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        insertpngPath(emoticon: emoticon)
    }
    
    /**普通表情：图文混排*/
    private func insertpngPath(emoticon: Emoticon) {
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        //根据图片路径创建属性字符串
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        //创建可变的属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        //获取光标所在的位置
        let range = selectedRange
        //替换属性字符串
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        //显示属性字符串
        attributedText = attrMStr
        //将文字的大小重置
        self.font = font
        //将光标设置回原来位置 + 1
        selectedRange = NSMakeRange(range.location + 1, 0)
    }

}

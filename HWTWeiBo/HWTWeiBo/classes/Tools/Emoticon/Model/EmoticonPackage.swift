//
//  EmoticonPackage.swift
//  表情键盘demo
//
//  Created by hegaokun on 2016/12/30.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    var emoticons: [Emoticon] = [Emoticon]()
    init(id: String) {
        super.init()
        //最近表情包分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        //根据 id 拼接 info.plist 的路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        //根据 plist 文件的路径读取数据
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        //遍历数组
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon(dict: dict))
            index += 1
            if index == 20 {
                //添加删除表情
                emoticons.append(Emoticon(isRemove: true))
                index = 0
            }
        }
        //添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    
    private func addEmptyEmoticon(isRecently: Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        emoticons.append(Emoticon(isRemove: true))
    }
}

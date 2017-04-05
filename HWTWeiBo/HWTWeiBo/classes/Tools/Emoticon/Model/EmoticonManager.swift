//
//  EmoticonManager.swift
//  表情键盘demo
//
//  Created by hegaokun on 2016/12/30.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class EmoticonManager {
    var packages: [EmoticonPackage] = [EmoticonPackage]()
    init() {
        //1.添加最近表情的包
        packages.append(EmoticonPackage(id: ""))
        //2.添加默认表情的包
        packages.append(EmoticonPackage(id: "com.sina.default"))
        //3.添加 emoji 表情的包
        packages.append(EmoticonPackage(id: "com.apple.emoji"))
        //4.添加浪小花表情的包
        packages.append(EmoticonPackage(id: "com.sina.lxh"))
    }
}

//
//  UIButton-Extension.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/11/29.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

extension UIButton {
    //swift 中类方法是以 class 开头的方法，类似OC
    /*
     class func createButton(imageName: String, bgImageName: String) -> UIButton {
     let btn = UIButton()
     btn.setImage(UIImage(named: imageName), for: .normal)
     btn.setImage(UIImage(named: imageName), for: .highlighted)
     btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
     btn.setBackgroundImage(UIImage(named: bgImageName), for: .highlighted)
     btn.sizeToFit()
     return btn
     }
     */
    /*
     convenience : 遍历，使用 convenience 修饰的构造函数叫做遍历构造函数
     遍历构造函数通常在对系统的类进行构造函数的扩充时使用
     遍历构造函数的特点：
        1.遍历构造函数通常都是写在 extension 里面
        2.遍历构造函数 init 前面需要加 convenience
        3.在遍历构造函数中需要明确的调用 self.init()
    */
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor: UIColor, fontSize: CGFloat, title: String) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}

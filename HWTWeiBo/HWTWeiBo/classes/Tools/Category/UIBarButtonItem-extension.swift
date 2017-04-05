//
//  UIBarButtonItem-extension.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/1.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //方法一
    convenience init(imageName: String) {
        self.init()
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.customView = btn
    }
    
    //方法二
//    convenience init(imageName: String) {
//        let btn = UIButton()
//        btn.setImage(UIImage(named: imageName), for: .normal)
//        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
//        btn.sizeToFit()
//        self.init(customView: btn)
//    }

}

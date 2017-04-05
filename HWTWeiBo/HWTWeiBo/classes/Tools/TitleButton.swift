//
//  TitleButton.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/1.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    //MARK:- 重写 init 函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    //swift规定：重写控件的 init(frame:) 方法或者 init() 方法，必须重写 init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 10
    }
}

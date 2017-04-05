//
//  ComposeTextView.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/27.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    //MARK:- 懒加载属性
    lazy var placeHolderLabel: UILabel = UILabel()
    //加载xib先执行 init 构造方法（主要用来添加子控件）
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    //然后再执行 awakeFromNib 方法（主要初始化控件约束或者frame,文字颜色等属性）
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:- 设置 UI
extension ComposeTextView {
    func setupUI() {
        addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        //设置内容的内间距
        textContainerInset = UIEdgeInsetsMake(8, 6, 0, 6)
    }
}

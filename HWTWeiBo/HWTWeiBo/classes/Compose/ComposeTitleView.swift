//
//  ComposeTitleView.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/27.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    //MARK: - 懒加载属性
    lazy var titleLabel: UILabel = UILabel()
    lazy var screenNameLabel: UILabel = UILabel()
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 设置 UI
extension ComposeTitleView {
    func setupUI() {
        //将子控件添加到 view 中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        //设置约束
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        //设置 label 属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        //设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareIntance.account?.screen_name
    }
}

//
//  EmoticonViewCell.swift
//  表情键盘demo
//
//  Created by hegaokun on 2016/12/30.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    //MARK:- 懒加载属性
    lazy var emoticonBtn: UIButton = UIButton()
    //MARK:- 定义属性
    var emticon: Emoticon? {
        didSet {
            guard let emoticon = emticon else {
                return
            }
            //设置 emoticonBtn 按钮
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            //设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    
    //MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- 设置 UI
extension EmoticonViewCell {
    func setupUI() {
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = contentView.bounds
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}

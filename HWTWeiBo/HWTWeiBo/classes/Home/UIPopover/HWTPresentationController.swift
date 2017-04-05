//
//  HWTPresentationController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/1.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class HWTPresentationController: UIPresentationController {
    //MARK:- 对外提供的属性
    var presentedFrame: CGRect = CGRect.zero
    //MARK:- 懒加载属性
    lazy var coverView: UIView = UIView()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        //设置弹出View的尺寸
        presentedView?.frame = presentedFrame
        //添加蒙版
        setupCoverView()
    }
}

extension HWTPresentationController {
    func setupCoverView() {
        //添加蒙版
        containerView?.insertSubview(coverView, at: 0)
        //设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        //添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(HWTPresentationController.coverViewClik))
        coverView.addGestureRecognizer(tapGes)
        
    }
}

//MARK:- 事件监听
extension HWTPresentationController {
    func coverViewClik() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

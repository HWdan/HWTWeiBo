//
//  MessageViewController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/11/28.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }
}

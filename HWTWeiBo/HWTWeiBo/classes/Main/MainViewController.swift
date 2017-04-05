//
//  MainViewController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/11/28.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    //MARK:- 懒加载属性
//    lazy var imageNames = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    lazy var composeBtn : UIButton  = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
    }
    
//    //需要调整tabBar必须在 viewWillAppear 里面调整，如果在 viewDidLoad 调整，之后还是会被 viewWillAppear 调回原来的样子
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupTabbarItems()
//    }
}

//MARK:- 设置 UI 界面
extension MainViewController {
    //设置 composeBtn 按钮
    func setupComposeBtn() {
        //将 composeBtn 添加到tabbar中
        tabBar.addSubview(composeBtn)
        //设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        //监听发布按钮的点击
        //Selector两种写法：1.Selector("composeBtnClick")  2."composeBtnClick"
        composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: .touchUpInside)
    }
//    //设置 Tabbar
//    func setupTabbarItems() {
//        //1.遍历所有的item
//        for i in 0..<tabBar.items!.count {
//            //2.获取item
//            let item = tabBar.items![i]
//            //3.如果下标是2，则该item不可以和用户交互
//            if i == 2 {
//                item.isEnabled = false
//                continue
//            }
//            //4.设置其他item的选中时候的图片
//            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
//        }
//    }
}

//MARK:- 事件监听
extension MainViewController {
    /*
     事件监听本质发送消息，但是发送消息是 OC 的特性：
     将方法包装成 @SEL --》 类中查找方法列表 --》 根据 @SEL 找到 imp 指针（函数）--》 执行函数。
     如果在swift中将一个函数声明 private ，那么该函数不会被添加到方法列表中。
     如果在 private 前面加 @objc ，那么该方法依然会被添加到方法列表中 (@objc private)
     */
    func composeBtnClick()  {
        //创建发布控制器
        let composeVC = ComposeViewController()
        //包装导航控制器
        let composeNav = UINavigationController(rootViewController: composeVC)
        //弹出控制器
        present(composeNav, animated: true, completion: nil)
    }
}

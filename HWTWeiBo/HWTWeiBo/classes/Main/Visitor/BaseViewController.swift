//
//  BaseViewController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/11/30.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    //MARK:- 懒加载属性
    lazy var visitorView: VisitorView = VisitorView.visitorView()
    //MARK:- 定义变量
    var isLogin: Bool = UserAccountViewModel.shareIntance.isLogin
    
    //MARK:- 系统回调函数
    override func loadView() {
        //判断要加载哪个view
        isLogin ? super.loadView() : setupVisitorView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
    }

}

//MARK:- 设置 UI 界面
extension BaseViewController {
    ///设置访客视图
    func setupVisitorView() {
        view = visitorView
        //监听访客视图中 注册 和 登录 按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClik), for: .touchUpInside)
    }
    
    ///设置导航栏左右的Item
    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseViewController.loginBtnClik))
        
    }
}

//MARK:- 事件监听
extension BaseViewController {
    func registerBtnClick() {
        print("registerBtnClick")
    }
    
    func loginBtnClik() {
        print("loginBtnClik")
        //创建授权控制器
        let oauthVC = OAuthViewController()
        //包装导航栏控制器
        let oauthNav = UINavigationController(rootViewController: oauthVC)
        //弹出控制器
        present(oauthNav, animated: true, completion: nil)
        
    }
}

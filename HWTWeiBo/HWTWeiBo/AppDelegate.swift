//
//  AppDelegate.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/11/25.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //计算属性(刚进入程序时，显示欢迎界面)
    var defaultViewController: UIViewController? {
        let isLogin = UserAccountViewModel.shareIntance.isLogin
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //设置全局 tabbar 和 NavigationBar 颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaultViewController
        window?.makeKeyAndVisible()
//        print(UserAccountViewModel.shareIntance.account?.access_token as Any)
        return true
    }
}


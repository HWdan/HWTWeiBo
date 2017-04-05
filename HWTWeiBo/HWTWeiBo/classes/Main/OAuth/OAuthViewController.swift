//
//  OAuthViewController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/6.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    //MARK:- xib的控件属性
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏内容
        setupnavigationBar()
        //加载网页
        loadPage()
    }

}

//MARK:- 设置 UI 界面
extension OAuthViewController {
    func setupnavigationBar() {
        //设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        //设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillItemClick))
        //设置标题
        title = "登录界面"
    }
    
    func loadPage() {
        //获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_url)"
        //创建对应的NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        //创建NSURLRequest对象
        let request = NSURLRequest(url: url as URL)
        //加载request对象
        webView.loadRequest(request as URLRequest)
    }
}

//MARK:- 事件监听函数
extension OAuthViewController {
    //关闭事件
    func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    //填充事件
    func fillItemClick() {
        //书写js代码：JavaScript
        //写死默认的账号和密码
        let jsCode = "document.getElementById('userId').value='';document.getElementById('passwd').value=''"
        //执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

//MARK:- UIWebViewDelegate方法
extension OAuthViewController: UIWebViewDelegate {
    //webView开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    //webView网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    //webView网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    //当准备加载某一个页面时，会执行该方法
    //返回值：true --> 继续加载该页面， false --> 不会加载该页面
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //获取加载网页的NSURL
        guard let url = request.url else {
            return true
        }
        //获取url中的字符串
        let urlString = url.absoluteString
        //判断该字符串中是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        //将code截取出来
        let code = urlString.components(separatedBy: "code=").last!
        //请求accessToken
        loadAccessToken(code: code)
        return false
    }
}

//MARK:- 请求数据
extension OAuthViewController {
    //请求accessToken
    func loadAccessToken(code: String) {
        NetworkTools.shareInstance.AccessToken(code: code) { (reslut, error) in
            //错误校验
            if error != nil {
                print(error!)
                return
            }
            //拿到结果
            guard let accountDict = reslut else {
                print("没有获取授权后的数据")
                return
            }
            //将字典转换成模型对象
            let account = UserAccount(dit: accountDict)
            //请求用户的信息
            self.loadUserInfo(account: account)
        }
    }
    //请求用户的信息
    func loadUserInfo(account: UserAccount) {
        //获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        //获取uid
        guard let uid = account.uid else {
            return
        }
        NetworkTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) { (result, error) in
            //错误校验
            if error != nil {
                print(error!)
                return
            }
            //拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            //将account对象保存
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewModel.shareIntance.accountPath)
            //将account对象设置到单例对象中(由于第一次登陆的时候，account对象是nil，而且是单例，所以必须重新赋值)
            UserAccountViewModel.shareIntance.account = account
            //退出当前控制器，并显示欢迎界面
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}

//MARK：-


//
//  UserAccountTool.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/14.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    //MARK:- 将类设计成单例
    static let shareIntance: UserAccountViewModel = UserAccountViewModel()
    
    //MARK:- 定义属性
    var account: UserAccount?
    
    //MARK:- 计算属性(沙盒路径)
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return NSString.path(withComponents: [accountPath,"account.plist"])
    }
    //MARK:- 计算属性(是否登录)
    var isLogin: Bool {
        if account == nil {
            return false
        }
        guard let expiresDate = account?.expires_date else {
            return false
        }
        return expiresDate.compare(Date()) == ComparisonResult.orderedDescending
    }
    
    //MARK:- 重写 init() 函数
    init() {
        //从沙盒读取归档的信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
    }
}

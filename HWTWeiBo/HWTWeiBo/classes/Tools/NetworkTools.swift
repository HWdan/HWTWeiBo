//
//  NetworkTools.swift
//  AFNetworking的封装
//
//  Created by hegaokun on 2016/12/2.
//  Copyright © 2016年 AAS. All rights reserved.
//

import AFNetworking

//MARK:- 定义枚举类型
enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

//MARK:- 单例
class NetworkTools: AFHTTPSessionManager {
    //let 是线程安全的  (单例 shareInstance)
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

//MARK:- 封装请求方法
extension NetworkTools {
    func request(metthodType: RequestType, urlString: String, parameters: [String: AnyObject], finished: @escaping (_ result: AnyObject?, _ error: Error?
        ) -> ()) {
        //定义成功的回调闭包
        let successCallBack = { (task: URLSessionDataTask, result: Any?) in
            finished(result as AnyObject, nil)
        }
        //定义失败的回调闭包
        let failureCallBack = { (task: URLSessionDataTask?, error: Error) in
            finished(nil, error)
        }
    
        if metthodType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

//MARK:- 请求accessToken
extension NetworkTools {
    func AccessToken(code: String, finished: @escaping (_ result: [String : AnyObject]?, _ error: NSError?) -> ()) {
        //获取请求的 urlString
        let urlString = "https://api.weibo.com/oauth2/access_token"
        //获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_url, "code" : code]
        //发送网络请求
        request(metthodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as! [String : AnyObject]?, error as NSError?)
        }
    }
}

//MARK:- 请求用户的信息
extension NetworkTools {
    func loadUserInfo(access_token: String, uid: String, finished: @escaping (_ result: [String : AnyObject]?, _ error: NSError?) -> ()) {
        //获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        //获取请求的参数
        let parameters = ["access_token" : access_token, "uid" : uid]
        //发送网络请求
        request(metthodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            finished(result as! [String : AnyObject]?, error as NSError?)
        }
    }
}

//MARK:- 请求首页数据
extension NetworkTools {
    func loadStatuses(since_id: Int, max_id: Int, finished: @escaping (_ result: [[String : AnyObject]]?, _ error: NSError?) -> ()) {
        //获取请求的URLString
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        //获取请求的参数
        let accessToken = (UserAccountViewModel.shareIntance.account?.access_token)!
        
        let parameters = ["access_token" :accessToken, "since_id" : "\(since_id)", "max_id" : "\(max_id)"]
        //发送网络请求
        request(metthodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            //获取字典的数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error as NSError?)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict["statuses"] as? [[String : AnyObject]], error as NSError?)
        }
        
    }
}

//MARK:- 发送微博
extension NetworkTools {
    func sendStatus(statusText: String, isSuccess: @escaping (_ isSuccess: Bool) -> ()) {
        //获取请求的URL
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        //获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText]
        //发送网络请求
        request(metthodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            if result != nil {
                isSuccess(true)
            } else {
                isSuccess(false)
            }
        }
    }
}

//MARK:- 发送微博并携带照片
extension NetworkTools {
    func sendStatus(statusText: String, image: UIImage, isSuccess: @escaping (_ isSuccess: Bool) -> ()) {
        //获取请求的URL
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        //获取请求的参数
        let parameters = ["access_token" : (UserAccountViewModel.shareIntance.account?.access_token)!, "status" : statusText,]
        //发送网络请求
        post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            //图片转为二进制上传
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.png", mimeType: "image/png")
            }
            
        }, progress: nil, success: { (_, _) in
            isSuccess(true)
        }, failure: { (_, error) in
            print(error)
        })
    }
}


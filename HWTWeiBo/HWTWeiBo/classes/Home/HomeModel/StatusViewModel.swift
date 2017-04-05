//
//  StatusViewModel.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/20.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    //MARK:- 定义属性
    var status: Status?
    
    //MARK:- 对数据处理的属性
    var sourceText: String?             //处理来源数据
    var createAtText: String?           //处理创建时间
    var verifiedImage: UIImage?         //处理用户认证图标
    var vipImage: UIImage?              //处理用户会员等级
    var profileUrl: NSURL?              //处理用户头像的地址
    var picUrls: [NSURL] = [NSURL]()    //处理微博配图的数据
    
    //MARK:- 自定义构造函数
    init(status: Status) {
        self.status = status
        //1.对来源数据处理
        if let source = status.source, status.source != "" {
            //获取起始位置和截取长度
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            //对来源的字符串进行处理
            sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        //2.处理时间显示
        if let createAt = status.created_at {
            createAtText = NSDate.createDateString(creatAtStr: createAt)
        }
        //3.处理用户认证
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        //处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
             vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        //处理用户头像的地址
        let profileUrlString = status.user?.profile_image_url ?? ""
        profileUrl = NSURL(string: profileUrlString)
        //判断是原创配图还是转发配图
        let picUrlDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        //处理配图数据
        if let picUrlDicts = picUrlDicts {
            for picUrlDict in picUrlDicts {
                guard let picUrlString = picUrlDict["thumbnail_pic"] else {
                    continue
                }
                picUrls.append(NSURL(string: picUrlString)!)
            }
        }
    }
}

//
//  NSDate-Extension.swift
//  时间处理
//
//  Created by hegaokun on 2016/12/20.
//  Copyright © 2016年 AAS. All rights reserved.
//

import Foundation

extension NSDate {
    class func createDateString(creatAtStr: String) -> String {
        /*
         创建时间格式对象
         EEE 代表星期
         MM  代表月份
         dd  代表天数
         HH  代表小时
         mm  代表分钟
         ss  代表秒数
         Z   代表时区
         */
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        //将字符串时间，转成NSDate类型
        guard let createDate = fmt.date(from: creatAtStr) else {
            return ""
        }
        //获取当前时间
        let nowDate = Date()
        //计算创建时间和当前时间的时间差
        let interval = nowDate.timeIntervalSince(createDate)
        //显示“刚刚”
        if interval < 60 {
            return "刚刚"
        }
        //显示“几分钟前”
        if interval < 60 * 60 {
            return "\(Int(interval / 60))分钟前"
        }
        //显示“几小时前”
        if interval < 60 * 60 * 24 {
            return "\(Int(interval / (60 * 60)))小时前"
        }
        //创建日历对象
        let calendar = NSCalendar.current
        //显示昨天“昨天 12：00”
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //显示一年之内“12-19 18:02”
        let cmps = calendar.dateComponents([Calendar.Component.year], from: createDate, to: nowDate)
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //显示超过一年的“2016-12-20 15：07”
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr

    }
}

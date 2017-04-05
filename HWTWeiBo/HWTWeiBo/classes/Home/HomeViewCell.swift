//
//  HomeViewCell.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/21.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 15
private let itemMargin: CGFloat = 10

class HomeViewCell: UITableViewCell {
    //MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: HYLabel!
    @IBOutlet weak var retweetedBgView: UIView!
    
    //MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    //MARK:- 自定义属性
    var viewModel: StatusViewModel? {
        didSet {
            //nil值校验
            guard let viewModel = viewModel else {
                return
            }
            //设置头像
            iconView.sd_setImage(with: viewModel.profileUrl as? URL, placeholderImage: UIImage(named: "avatar_default_small"))
            //设置认证图标
            verifiedView.image = viewModel.verifiedImage
            //设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //设置昵称的文字颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            //会员图标
            vipView.image = viewModel.vipImage
            //设置时间的label
            timeLabel.text = viewModel.createAtText
            //设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自" + sourceText
            } else {
                sourceLabel.text = nil
            }
            //设置微博正文
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            //计算picView的宽度和高度的约束
            let picViewSize = calculatePicViewSize(count: viewModel.picUrls.count)
            picViewHCons.constant = picViewSize.height
            picViewWCons.constant = picViewSize.width
            //将 picUrl 数据传递给 picView
            picView.picUrls = viewModel.picUrls
            //设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, let retweetedText = viewModel.status?.retweeted_status?.text {
                    let retweetedText = "@" + "\(screenName)：" + retweetedText
                    retweetedContentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(statusText: retweetedText, font: retweetedContentLabel.font)
                    //设置转发正文距离顶部的约束
                    retweetedContentLabelTopCons.constant = 15
                }
                //设置转发背景显示
                retweetedBgView.isHidden = false
            } else {
                retweetedContentLabel.text = nil
                //设置转发背景显示
                retweetedBgView.isHidden = true
                //设置转发正文距离顶部的约束
                retweetedContentLabelTopCons.constant = 0
            }
        }
    }
    //MARK:- 系统回调函数（xib加载完后，就会执行这个方法）
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置微博正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - edgeMargin * 2
        
        //设置HYlabel的内容
        contentLabel.matchTextColor = UIColor.purple
        retweetedContentLabel.matchTextColor = UIColor.purple
        //监听HYlabel的内容点击
        // 监听@谁谁谁的点击
        contentLabel.userTapHandler = { (label, user, range) in
            print(label)
            print(user)
            print(range)
        }
        // 监听链接的点击
        contentLabel.linkTapHandler = { (label, link, range) in
            print(label)
            print(link)
            print(range)
        }
        // 监听话题的点击
        contentLabel.topicTapHandler = { (label, topic, range) in
            print(label)
            print(topic)
            print(range)
        }
    }
}

//MARK:- 计算方法
extension HomeViewCell {
    func calculatePicViewSize(count: Int) -> CGSize {
        //没有配图
        if count == 0 {
            //没有配图就将距离底部工具栏约束设置为 0
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        //有配图就将距离底部工具栏约束设置为 10
        picViewBottomCons.constant = 10
        //取出 picView 的对应 layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        //单张图片
        if count == 1 {
            //取出图片
            let urlString = viewModel?.picUrls.last?.absoluteString
            guard let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString) else {
                return CGSize.zero
            }
            //设置一张图片 layout 的 itemSize
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2 )
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        //计算 imageView 的宽高
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        //设置其他张图片 layout 的 itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        //四张图片
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        //其他张配图,计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        //计算 picView 的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        //计算 picView 的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}

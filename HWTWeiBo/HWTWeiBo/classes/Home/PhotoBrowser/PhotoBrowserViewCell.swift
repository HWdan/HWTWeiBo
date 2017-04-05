//
//  PhotoBrowserViewCell.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2017/1/10.
//  Copyright © 2017年 AAS. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate: NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowserViewCell: UICollectionViewCell {
    //MARK: - 定义属性
    var picUrl: NSURL? {
        didSet {
            setupContent(picUrl: picUrl)
        }
    }
    
    var delegate: PhotoBrowserViewCellDelegate?
    //MARK: - 懒加载属性
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var imageView: UIImageView = UIImageView()
    lazy var progressView: ProgressView = ProgressView()
    
    //MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserViewCell {
    func setupUI() {
        //添加子控件
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        //设置 frame
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        //隐藏进度条
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        //监听 imageView 的点击
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(PhotoBrowserViewCell.imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
    }
}

extension PhotoBrowserViewCell {
    func imageViewClick() {
        delegate?.imageViewClick()
    }
}


extension PhotoBrowserViewCell {
    func setupContent(picUrl: NSURL?) {
        guard let picUrl = picUrl else {
            return
        }
        //取出 image 对象
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)!
        //计算 imageView 的 frame
        let width = UIScreen.main.bounds.width
        let height = (width / image.size.width) * image.size.height
        var y: CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigUrl(smallUrl: picUrl) as URL!, placeholderImage: image, options: [], progress: { (current, total) in
            self.progressView.progress = CGFloat(current / total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        //设置 scrollview 的contentSize
        scrollView.contentSize = CGSize(width: 0, height: height);
    }
    
    private func getBigUrl(smallUrl: NSURL) -> NSURL {
        let smallUrlString = smallUrl.absoluteString
        let bigUrlString = smallUrlString?.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return NSURL(string: bigUrlString!)!
    }
    
}

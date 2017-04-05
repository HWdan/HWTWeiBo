//
//  PicCollectionView.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/22.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    //MARK:- 定义属性
    var picUrls: [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
    }
}

//MARK:- UICollectionViewDataSource 代理
extension PicCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        //给cell设置数据
        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取通知需要传递的参数
        let userInfo = [ShowPhotoBrowserIndexKey : indexPath, ShowPhotoBrowserUrlsKey : picUrls] as [String : Any]
        //发出通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}

//MARK:- AnimatorPresentedDelegate
extension PicCollectionView: AnimatorPresentedDelegate {
    func startRect(indexPath: NSIndexPath) -> CGRect {
        //获取 cell
        let cell = self.cellForItem(at: indexPath as IndexPath)!
        //获取 cell 的 frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
        return startFrame
        
    }
    func endRect(indexPath: NSIndexPath) -> CGRect {
        //获取该位置的 image 对象
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)
        //计算结束后的 frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y: CGFloat = 0
        if h > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
        
    }
    func imageView(indexPath: NSIndexPath) -> UIImageView {
        //创建 UIImageView 对象
        let imageView = UIImageView()
        //获取该位置的 image 对象
        let picUrl = picUrls[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)
        //设置 imageView 的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}


//MARK:-  创建类 PicCollectionViewCell
class PicCollectionViewCell: UICollectionViewCell {
    //MARK:- 定义模型属性
    var picUrl: NSURL? {
        didSet {
            guard let picUrl = picUrl else {
                return
            }
            iconView.sd_setImage(with: picUrl as URL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    //MARK:- 控件属性
    @IBOutlet weak var iconView: UIImageView!
}


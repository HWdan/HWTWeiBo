//
//  PhotoBrowserController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2017/1/10.
//  Copyright © 2017年 AAS. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    //MARK: - 定义属性
    var indexPath: NSIndexPath
    var picUrls: [NSURL]
    //MARK: - 懒加载属性
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    lazy var closeBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关 闭")
    lazy var saveBtn: UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保 存")
    
    //MARK: - 自定义构造函数
    init(indexPath: NSIndexPath, picUrls: [NSURL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置 UI 界面
        setupUI()
        //滚动到对应的图片
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
    override func loadView() {
        super.loadView()
        view.frame.size.width += 20
    }
}

//MARK: - 设置 UI 界面
extension PhotoBrowserController {
    func setupUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //设置frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        //点击事件
        closeBtn.addTarget(self, action: #selector(PhotoBrowserController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserController.saveBtnClick), for: .touchUpInside)
        
        //设置 collectionView 
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
    }
}

//MARK: - 事件监听
extension PhotoBrowserController {
    func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveBtnClick() {
        //获取当前正在显示的 image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        //将照片 image 对象保存到相册
        //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserController.image), nil)
    }
    
}

//MARK: - 保存照片的事件
extension PhotoBrowserController {
    func image(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: AnyObject) {
        var showInfo = ""
        if didFinishSavingWithError != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

//MARK: - UICollectionViewDataSource
extension PhotoBrowserController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        return cell
    }
}

//MARK: - PhotoBrowserViewCellDelegate
extension PhotoBrowserController: PhotoBrowserViewCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}
//MARK: - AnimatorDismissDelegate
extension PhotoBrowserController: AnimatorDismissDelegate {
    func indexPathForDismissView() -> NSIndexPath {
        //获取当前正在显示的 indexPath
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)! as NSIndexPath
    }
    func imageViewForDismissView() -> UIImageView {
        //创建 UIImageView 对象
        let imageView = UIImageView()
        //设置 imageView 的 frame
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        //设置 imageView 的属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}

//MARK: - 自定义布局
class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //设置 itmeSize
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        //滚动方向
        scrollDirection = .horizontal
        //设置 CollectionView 的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

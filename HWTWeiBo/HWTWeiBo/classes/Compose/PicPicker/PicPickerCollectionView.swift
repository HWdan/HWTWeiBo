//
//  PicPickerCollectionView.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/27.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

private let picPickerCell = "picPickerCell"
private let edgeMargin: CGFloat = 15

class PicPickerCollectionView: UICollectionView {
    //MARK:- 定义属性
    var images: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    //MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumInteritemSpacing = edgeMargin
        layout.minimumLineSpacing = edgeMargin
        
        //注册 cell
        register(UINib(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        //设置 CollectionView 的内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
    }
}

extension PicPickerCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        cell.backgroundColor = UIColor.lightGray
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        return cell
    }
}

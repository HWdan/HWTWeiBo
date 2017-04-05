//
//  PicPickerViewCell.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/28.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    //MARK:- 控件属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var removePhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- 定义属性
    var image: UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPhotoBtn.isUserInteractionEnabled = false
                removePhotoBtn.isHidden = false
            } else {
                imageView.image = nil
                addPhotoBtn.isUserInteractionEnabled = true
                removePhotoBtn.isHidden = true
            }
        }
    }
    
    //MARK:- 事件监听
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }
    @IBAction func removePhotoClick() {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: imageView.image)
    }

}

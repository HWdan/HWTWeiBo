//
//  ComposeViewController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/12/27.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {
    //MARK: - 懒加载属性
    lazy var titleView: ComposeTitleView = ComposeTitleView()
    lazy var images: [UIImage] = [UIImage]()
    lazy var emticonVC: EmoticonController = EmoticonController {[weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon:emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
    //MARK: - 约束属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHCons: NSLayoutConstraint!
    
    //MARK: - xib 控件属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        setupNavigationBar()
        //注册通知
        setupNotifications()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - 选择图片按钮事件
    @IBAction func picPickerBtnClick() {
        textView.resignFirstResponder()
        picPickerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    //MARK: - 表情按钮事件
    @IBAction func emotionBtnClick() {
        //退出键盘
        textView.resignFirstResponder()
        //切换键盘
        textView.inputView = textView.inputView != nil ? nil : emticonVC.view
        //弹出键盘
        textView.becomeFirstResponder()
    }
}


//MARK: - 设置 UI 
extension ComposeViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(ComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(ComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    func setupNotifications() {
        //监听键盘的弹出
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //监听添加照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.addPhotoClick), name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
        //监听删除照片的按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(ComposeViewController.removePhotoClick), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
    }
}

//MARK: - 事件监听
extension ComposeViewController {
    func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    func sendItemClick() {
        textView.resignFirstResponder()
        //获取发送微博的正文
        let statusText = textView.getEmoticonString()
        //定义回调的闭包
        let finishedCallBack = { (isSuccess: Bool) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败！")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功！")
            self.dismiss(animated: true, completion: nil)
        }
        
        if let image = images.first {
            //调用接口发送微博正文和图片
            NetworkTools.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishedCallBack)
        } else {
            //调用接口发送微博正文
            NetworkTools.shareInstance.sendStatus(statusText: statusText, isSuccess: finishedCallBack)
        }
        
    }
    
    func keyboardWillChangeFrame(note: NSNotification) {
        //获取动画执行时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey]
        //获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - endFrame.origin.y
        toolBarBottomCons.constant = margin
        //执行动画
        UIView.animate(withDuration: duration as! TimeInterval) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - 添加照片和删除照片的事件
extension ComposeViewController {
    func addPhotoClick() {
        //判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        //创建照片选择控制器
        let ipc = UIImagePickerController()
        //设置照片源
        ipc.sourceType = .photoLibrary
        //设置代理
        ipc.delegate = self
        present(ipc, animated: true, completion: nil)
    }
    
    func removePhotoClick(note: NSNotification) {
        //获取 image 对象
        guard let image = note.object as? UIImage else {
            return
        }
        //获取 image 对象所在的下标值
        guard let index = images.index(of: image) else {
            return
        }
        //把图片从数组中删除
        images.remove(at: index)
        //重新给控制器赋值新的数组
        picPickerView.images = images
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //将选中的图片添加到数组 images 中
        images.append(image)
        //将数组赋给 collectionview ，让 collectionview 处理数据展示
        picPickerView.images = images
        //退出选中图片控制器
        picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UITextViewDelegate
extension ComposeViewController: UITextViewDelegate {
    //文字发生改变
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    //textView 发生滚动的时候
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
    
}

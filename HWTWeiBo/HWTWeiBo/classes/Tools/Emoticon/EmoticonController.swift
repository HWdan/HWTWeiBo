//
//  EmoticonController.swift
//  表情键盘demo
//
//  Created by hegaokun on 2016/12/29.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit

private let EmoticonCell = "EmoticonCell"

class EmoticonController: UIViewController {
    //MARK: - 定义属性
    var emoticonCallBack: (_ emticon: Emoticon) -> ()
    
    //MARK: - 懒加载属性
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonCollectionViewLayout())
    lazy var toolBar: UIToolbar = UIToolbar()
    lazy var manager = EmoticonManager()
    
    //MARK: - 自定义构造函数
    init(emoticonCallBack: @escaping (_ emoticon: Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - 设置 UI
extension EmoticonController {
    func setupUI() {
        //添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purple
        toolBar.backgroundColor = UIColor.darkGray
        //设置子控件的 frame (纯代码控制约束需要设置 translatesAutoresizingMaskIntoConstraints 为 false)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" :toolBar, "cView" : collectionView] as [String : Any]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[cView]-0-[tBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        //创建 CollectionView
        prepareForCollectionView()
        //创建tooBar
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        //注册 cell 和设置数据源
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: EmoticonCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        //定义 toolBar 中的 titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        //遍历标题，创建 item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(EmoticonController.itemClick))
            item.tag = index
            index += 1
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        }
        tempItems.removeLast()
        //设置 tooBar 的 items 数组
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
}

extension EmoticonController {
    func itemClick(item: UIBarButtonItem) {
        let indexPath = NSIndexPath(item: 0, section: item.tag)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: true)
    }
}

extension EmoticonController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmoticonCell, for: indexPath) as! EmoticonViewCell
        let package = manager.packages[indexPath.section]
        let emticon = package.emoticons[indexPath.item]
        cell.emticon = emticon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        //将点击的表情插入最近分组中
        insertRecentlyEmoticon(emoticon: emoticon)
        //将表情回调给外面控制器
        emoticonCallBack(emoticon)
    }
    
    private func insertRecentlyEmoticon(emoticon: Emoticon) {
        //如果是空白表情或者删除按钮，不需要插入
        if emoticon.isRemove || emoticon.isEmpty {
            return
        }
        //删除一个表情
        if manager.packages.first!.emoticons.contains(emoticon) {
            let index = (manager.packages.first?.emoticons.index(of: emoticon))!
            manager.packages.first?.emoticons.remove(at: index)
            
        } else {
            //原来没有这个表情,就删除最后一个
            manager.packages.first?.emoticons.remove(at: 19)
        }
        //将emoticon插入最近分组
        manager.packages.first?.emoticons.insert(emoticon, at: 0)
    }
    
}

class EmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        //计算 itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        //设置 layout 的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        //设置 collectionview 的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = ((collectionView?.bounds.height)! - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsetsMake(insetMargin, 0, insetMargin, 0)
        
    }
}

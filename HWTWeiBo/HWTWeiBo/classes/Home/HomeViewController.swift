//
//  HomeViewController.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2016/11/28.
//  Copyright © 2016年 AAS. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    //MARK:- 懒加载属性
    lazy var titleBtn: TitleButton = TitleButton()
    lazy var popoverAnimate: PopoverAnimate = PopoverAnimate {[weak self] (presented) in
        //改变按钮的状态
        self?.titleBtn.isSelected = presented
    }
    lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    lazy var tipLabel: UILabel = UILabel()
    lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()

    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //没有登录时设置的内容
        visitorView.addRotationAnim()
        if !isLogin {
            return
        }
        //设置导航栏的内容
        setupNavigationBar()
        //动态更新 tableView 的约束
        tableView.rowHeight = UITableViewAutomaticDimension
        //预估cell的高度
        tableView.estimatedRowHeight = 200
        //布局刷新 header
        setupHeaderView()
        //布局加载更多 footer
        setupFooterView()
        //设置提示 label
        setupTipLabel()
        //监听通知
        setupNotifications()
    }
}

//MARK:- 设置 UI 界面
extension HomeViewController {
    func setupNavigationBar() {
        //设置左边的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        //设置右边的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //设置titleView
        let title = UserAccountViewModel.shareIntance.account?.screen_name
        titleBtn.setTitle("\(title!)", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClik(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    //刷新header布局
    func setupHeaderView() {
        //创建headerView
        let header = MJRefreshStateHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatues))
        //设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        //设置tableview的header
        tableView.mj_header = header
        //进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    //加载更多布局
    func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatues))
    }
    
    //提示 label
    func setupTipLabel() {
        //将 tipLabel 添加到父控件
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        //设置 tipLabel 的 frame
        tipLabel.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 32)
        //设置 tipLabel 的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showPhotoBrowser), name: NSNotification.Name(rawValue: ShowPhotoBrowserNote), object: nil)
    }
}

//MARK:- 事件监听函数
extension HomeViewController {
    //加载微博数据
    func titleBtnClik(titleBtn: TitleButton) {
        //创建弹出的控制器
        let popoverVC = PopoverViewController()
        //设置控制器的弹出样式
        popoverVC.modalPresentationStyle = .custom
        //设置转场的代理
        popoverVC.transitioningDelegate = popoverAnimate
        popoverAnimate.hwtPresentedFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        //弹出控制器
        present(popoverVC, animated: true, completion: nil)
    }
    
    //加载最新的数据(下拉刷新)
    func loadNewStatues() {
        //请求网络数据
        loadStatuses(isNewData: true)
    }
    
    //上拉加载更多数据
    func loadMoreStatues() {
        loadStatuses(isNewData: false)
    }
    
    func showPhotoBrowser(note: NSNotification) {
        //取出数据
        let indexPath = note.userInfo![ShowPhotoBrowserIndexKey] as! NSIndexPath
        let picUrls = note.userInfo![ShowPhotoBrowserUrlsKey] as! [NSURL]
        let object = note.object as! PicCollectionView
        
        //创建控制器并跳转
        let photoBrowserVC = PhotoBrowserController(indexPath: indexPath, picUrls: picUrls)
        //设置 modal 样式
        photoBrowserVC.modalPresentationStyle = .custom
        //设置转场的代理
        photoBrowserVC.transitioningDelegate = photoBrowserAnimator
        //设置动画的代理
        photoBrowserAnimator.presentedDelegate = object
        photoBrowserAnimator.indexPath = indexPath
        photoBrowserAnimator.dismissDelegate = photoBrowserVC
        //以 modal 的样式弹出控制器
        present(photoBrowserVC, animated: true, completion: nil)
        
    }
    
}

//MARK:- 请求数据
extension HomeViewController {
    func loadStatuses(isNewData: Bool) {
        //获取since_id/max_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            //错误校验
            if error != nil {
                print(error!)
                return
            }
            //获取可选类型的数据
            guard let resultArray = result else {
                return
            }
            //遍历微博对应的字典
            var tempViewModel = [StatusViewModel]()
            for statusDict in resultArray {
                let status = Status(dict: statusDict)
                let viewModel = StatusViewModel(status: status)
                tempViewModel.append(viewModel)
            }
            //将数据放入成员变量的数组中
            if isNewData {
                self.viewModels = tempViewModel + self.viewModels
            } else {
                self.viewModels += tempViewModel
            }
            //缓存图片
            self.cacheImages(viewModels: tempViewModel)
        }
    }
    private func cacheImages(viewModels: [StatusViewModel]) {
        //创建 group 组
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "downloadImage")
        //缓存图片
        for viewModel in viewModels {
            for picUrl in viewModel.picUrls {
                group.enter()
                queue.async(group: group) {
                    SDWebImageManager.shared().downloadImage(with: picUrl as URL!, options: [], progress: nil, completed: { (_, _, _, _, _) in
                        group.leave()
                    })
                }
            }
        }
        group.notify(queue: DispatchQueue.main) {
            //刷新表格
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            //显示提示的 label
            self.showTipLabel(count: viewModels.count)
        }
    }
    
    func showTipLabel(count: Int) {
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条微博"
        //执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: {
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

//MARK:- UITableViewDataSource
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        //给cell设置数据
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}

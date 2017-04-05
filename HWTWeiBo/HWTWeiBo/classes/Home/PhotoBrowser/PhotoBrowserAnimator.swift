//
//  PhotoBrowserAnimator.swift
//  HWTWeiBo
//
//  Created by hegaokun on 2017/1/18.
//  Copyright © 2017年 AAS. All rights reserved.
//

import UIKit

//面向协议开发
protocol AnimatorPresentedDelegate: NSObjectProtocol {
    func startRect(indexPath: NSIndexPath) -> CGRect
    func endRect(indexPath: NSIndexPath) -> CGRect
    func imageView(indexPath: NSIndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate: NSObjectProtocol {
    func indexPathForDismissView() -> NSIndexPath
    func imageViewForDismissView() -> UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented: Bool = false
    var presentedDelegate: AnimatorPresentedDelegate?
    var dismissDelegate: AnimatorDismissDelegate?
    
    var indexPath: NSIndexPath?
}

extension PhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? aninmationForPresentedView(transitionContext: transitionContext) : animationForDismissView(transitionContext: transitionContext)
        }
    
    ///弹出动画
    func aninmationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        //取出弹出的 view
        let prensentedView = transitionContext.view(forKey: .to)!
        //将 prensentedView 添加到 containView 中
        transitionContext.containerView.addSubview(prensentedView)
        //获取执行动画的 iamgeView
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        let startRect = presentedDelegate.startRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        //执行动画
        prensentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            prensentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    ///消失动画
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning){
        //取出消失的 view
        let dismissView = transitionContext.view(forKey: .from)!
        dismissView.removeFromSuperview()
        //获取执行动画的 imageView
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismissView()
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.startRect(indexPath: indexPath)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}

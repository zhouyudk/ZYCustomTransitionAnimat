//
//  ZYPresentDismissCircleAnimat.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 22/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentDismissCircleAnimat: NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate {
    private let firstAnimatKey = "PathFirst"
    private let animatTime = 0.75

    private var fromView: UIView?
    private var transitionCont: UIViewControllerContextTransitioning?
    private var maskView: UIView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionCont = transitionContext
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        
        let toView = toVC?.view
        fromView = fromVC?.view
        
        toView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toView!)
        if let fv = fromView {
            containerView.addSubview(fv)
        }
        
        maskView = UIView(frame: containerView.bounds)
        maskView.backgroundColor = UIColor.black
        containerView.addSubview(maskView)
        
        let startPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), cornerRadius: 0)
        startPath.append(UIBezierPath(arcCenter: maskView.center, radius: UIScreen.main.bounds.height/2+100, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false))
        
        let endPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), cornerRadius: 0)
        endPath.append(UIBezierPath(arcCenter: maskView.center, radius: 15, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        maskView.layer.mask = maskLayer
        
        //第一阶段圆变小,执行removeView移除fromView，动画逆向执行
        let maskLayerAnimat = CABasicAnimation(keyPath: "path")
        maskLayerAnimat.fromValue = startPath.cgPath
        maskLayerAnimat.toValue  = endPath.cgPath
        maskLayerAnimat.isRemovedOnCompletion = false
        maskLayerAnimat.fillMode = kCAFillModeForwards
        //动画完成后自动逆向变化
        maskLayerAnimat.autoreverses = true
        maskLayerAnimat.duration = animatTime
        maskLayerAnimat.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        maskLayerAnimat.delegate = self
        maskLayer.add(maskLayerAnimat, forKey: firstAnimatKey)
        
        self.perform(#selector(removeView), with: nil, afterDelay: animatTime)
        
    }
    @objc func removeView() {
        if let fv = fromView {
            fv.removeFromSuperview()
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        maskView.removeFromSuperview()
        transitionCont?.completeTransition(true)
    }
}

//
//  ZYDismissCircleAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissCircleAnimation: ZYAnimation {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
            else { return }
        let containerView = transitionContext.containerView
        
        toView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        let endPath = UIBezierPath(arcCenter: toView.center, radius: 1, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false)

        let startPath = UIBezierPath(arcCenter: toView.center, radius: UIScreen.main.bounds.height/2+100, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        fromView.layer.mask = maskLayer
        
        //第一阶段圆变小,执行removeView移除fromView，动画逆向执行
        let maskLayerAnimat = CABasicAnimation(keyPath: "path")
        maskLayerAnimat.fromValue = startPath.cgPath
        maskLayerAnimat.toValue  = endPath.cgPath
        maskLayerAnimat.duration = ZYPresentSpreadAnimation.duration
        maskLayerAnimat.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayerAnimat.delegate = self
        maskLayer.add(maskLayerAnimat, forKey: "present")
        
        self.animationEndClosure = {
            fromView.layer.mask = nil
            transitionContext.completeTransition(true)
        }
        
    }
}

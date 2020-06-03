//
//  ZYPresentCircleAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 22/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentCircleAnimation: ZYAnimation {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
        let toView = transitionContext.view(forKey: .to),
        let fromView = transitionContext.view(forKey: .from)
        else { return }
        let containerView = transitionContext.containerView
        
        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        let startPath = UIBezierPath(arcCenter: toView.center, radius: 1, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false)

        //hypot函数，已知直角三角形两直角边求斜边
        let endPath = UIBezierPath(arcCenter: toView.center, radius: hypot(screenHeight/2, screenWidth/2) , startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: false)

        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        toView.layer.mask = maskLayer
        
        //第一阶段圆变小,执行removeView移除fromView，动画逆向执行
        let maskLayerAnimat = CABasicAnimation(keyPath: "path")
        maskLayerAnimat.fromValue = startPath.cgPath
        maskLayerAnimat.toValue  = endPath.cgPath
        maskLayerAnimat.duration = ZYAnimation.duration
        maskLayerAnimat.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)// kCAMediaTimingFunctionEaseIn
        maskLayerAnimat.delegate = self
        maskLayer.add(maskLayerAnimat, forKey: "present")

        self.animationEndClosure = {
            toView.layer.mask = nil
            transitionContext.completeTransition(true)
        }
        
    }
}

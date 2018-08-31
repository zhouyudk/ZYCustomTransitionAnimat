//
//  ZYDismissSpreadAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissSpreadAnimation: ZYAnimation {
    var direction: SpreadDirection
    
    init(direction d:SpreadDirection) {
        direction = d
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
            else { return }
        let containerView = transitionContext.containerView
        
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        var endPath = UIBezierPath(rect: CGRect(x: screenWidth, y: 0, width: 1, height: screenHeight))
        let startPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        switch direction {
        case .left:
            endPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: screenHeight))
        case .right:
            endPath = UIBezierPath(rect: CGRect(x: screenWidth, y: 0, width: 1, height: screenHeight))
        case .top:
            endPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        case .bottom :
            endPath = UIBezierPath(rect: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 1))
        default:
            break
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        fromView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = ZYAnimation.duration
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        maskLayer.add(animation, forKey: "next")
        
        self.animationEndClosure = {
            fromView.layer.mask = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

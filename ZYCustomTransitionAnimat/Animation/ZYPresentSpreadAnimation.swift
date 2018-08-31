//
//  ZYPresentSpreadAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 27/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentSpreadAnimation: ZYAnimation {
    
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
        
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)

        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        var startPath = UIBezierPath(rect: CGRect(x: screenWidth, y: 0, width: 1, height: screenHeight))
        let endPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        switch direction {
        case .left:
            startPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: screenHeight))
        case .right:
            startPath = UIBezierPath(rect: CGRect(x: screenWidth, y: 0, width: 1, height: screenHeight))
        case .top:
            startPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        case .bottom :
            startPath = UIBezierPath(rect: CGRect(x: 0, y: screenHeight, width: screenWidth, height: 1))
        default:
            break
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        toView.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.duration = ZYAnimation.duration
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        maskLayer.add(animation, forKey: "next")
        
        self.animationEndClosure = {
            toView.layer.mask = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}

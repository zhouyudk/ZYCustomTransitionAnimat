//
//  ZYDismissFoldAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 04/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissFoldAnimation: ZYAnimation,ZYFoldDelegate {
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

        let paperFoldingLayer = self.createFoldsLayer(rect: containerView.frame, foldView: fromView, direction: direction, duration: ZYAnimation.duration+0.5, isFold: true)
        containerView.layer.addSublayer(paperFoldingLayer)
        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        containerView.addSubview(toView)
        //对toView进行位移
        let closeFunction: ((CGFloat) -> CGFloat) = { (time) in
            return -cos(time * CGFloat.pi / 2) + 1
        }
        var closeAnimation: CAKeyframeAnimation!
        var fromValue: CGFloat
        var toValue: CGFloat
        var keyPath: String
        switch direction {
        case .right:
            keyPath = "position.x"
            fromValue = -fromView.frame.size.width / 2
            toValue = fromView.frame.size.width / 2
        case .left:
            keyPath = "position.x"
            fromValue = fromView.frame.size.width+fromView.frame.size.width / 2
            toValue =  fromView.frame.size.width / 2
        case .top:
            keyPath = "position.y"
            fromValue = fromView.frame.size.height+fromView.frame.size.height / 2
            toValue = fromView.frame.size.height / 2
        case .bottom:
            keyPath = "position.y"
            fromValue = -fromView.frame.size.height / 2
            toValue = fromView.frame.size.height / 2
        }
        closeAnimation = CAKeyframeAnimation.animationWith(keyPath: keyPath,
                                                           function: closeFunction,
                                                           fromValue: fromValue,
                                                           toValue: toValue)
        closeAnimation.fillMode = CAMediaTimingFillMode.forwards
        closeAnimation.isRemovedOnCompletion = false
        closeAnimation.duration = ZYAnimation.duration+0.5
        closeAnimation.delegate = self
        toView.layer.add(closeAnimation, forKey: "position")//加在layer上的动画要在结束时删除，否则会影响其他的动画
        self.animationEndClosure = {
            if transitionContext.transitionWasCancelled{
                toView.removeFromSuperview()
            }else{
                toView.frame = containerView.frame
            }
            toView.layer.removeAllAnimations()
            paperFoldingLayer.removeFromSuperlayer()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}

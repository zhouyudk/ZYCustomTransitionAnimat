//
//  ZYDismissPageAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissPageAnimation: ZYAnimation {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let tmpView = containerView.subviews.last
            else { return }
        
        
        
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        containerView.addSubview(tmpView)
        toView.isHidden = true
        
        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

        UIView.animate(withDuration: ZYAnimation.duration, animations: {
            tmpView.layer.transform = CATransform3DIdentity
        }) { (finish) in
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false)
            }else{
                tmpView.removeFromSuperview()
                toView.isHidden = false
                transitionContext.completeTransition(true)
            }

        }
        
    }
}

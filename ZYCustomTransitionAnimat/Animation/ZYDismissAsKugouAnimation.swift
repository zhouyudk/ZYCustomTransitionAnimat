//
//  ZYDismissAsKugouAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 03/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissAsKugouAnimation: ZYAnimation {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
        let toView = transitionContext.view(forKey: .to),
        let fromView = transitionContext.view(forKey: .from)
        else { return }
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        UIView.animate(withDuration: ZYAnimation.duration, animations: {
            fromView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        }) { (finish) in
            if transitionContext.transitionWasCancelled {
                toView.removeFromSuperview()
                transitionContext.completeTransition(false)
            }else{
                transitionContext.completeTransition(true)
            }
        }
    }
}

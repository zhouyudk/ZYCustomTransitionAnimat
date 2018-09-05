//
//  ZYPresentAsKugouAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 03/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentAsKugouAnimation: ZYAnimation {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let _ = transitionContext.view(forKey: .from)
            else { return }
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        toView.frame = CGRect(x: -screenWidth/2, y: screenHeight/2, width: screenWidth, height: screenHeight)
        toView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        toView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        
        UIView.animate(withDuration: ZYAnimation.duration, animations: {
            toView.transform = CGAffineTransform(rotationAngle: 0)
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

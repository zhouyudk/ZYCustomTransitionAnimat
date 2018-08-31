//
//  ZYPresentPageAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentPageAnimation: ZYAnimation {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from),
            let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: true)
            else { return }
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        containerView.addSubview(fromViewSnapshot)
        fromView.isHidden = true
    
        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        fromViewSnapshot.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        let point = CGPoint(x: 0, y: 0.5)
        fromViewSnapshot.frame = fromViewSnapshot.frame.offsetBy(dx: (point.x - fromViewSnapshot.layer.anchorPoint.x) * fromViewSnapshot.frame.size.width, dy: (point.y - fromViewSnapshot.layer.anchorPoint.y) * fromViewSnapshot.frame.size.height)
        fromViewSnapshot.layer.anchorPoint = point
        var transfrom3d = CATransform3DIdentity
        transfrom3d.m34 = -0.002
        containerView.layer.sublayerTransform = transfrom3d

        UIView.animate(withDuration: ZYAnimation.duration, animations: {
            fromViewSnapshot.layer.transform = CATransform3DMakeRotation(CGFloat(-Double.pi/2.665), 0, 1, 0)
        }) { (finish) in
            if transitionContext.transitionWasCancelled {
                fromViewSnapshot.removeFromSuperview()
                transitionContext.completeTransition(false)
            }else{
                transitionContext.completeTransition(true)
            }
            fromView.isHidden = false
        }
        
    }
}

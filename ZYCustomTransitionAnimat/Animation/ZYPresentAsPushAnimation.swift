//
//  ZYPresentAsPushAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 24/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentAsPushAnimation: ZYAnimation {
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        
        if let fv = fromView, let tv = toView {
            transitionContext.containerView.addSubview(fv)
            transitionContext.containerView.addSubview(tv)
        }
        
        toView?.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        fromView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        UIView.animate(withDuration: ZYPresentSpreadAnimation.duration, animations: {
            fromView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            toView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finish) in
            fromView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }  
}

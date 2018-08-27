//
//  ZYDismissAsPopAnimat.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 24/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissAsPopAnimat: NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        
        if let fv = fromView, let tv = toView {
            transitionContext.containerView.addSubview(tv)
            transitionContext.containerView.addSubview(fv)
        }
        
        toView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        fromView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        toView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.75, animations: {
            toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            fromView?.frame = CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { (finish) in
            if transitionContext.transitionWasCancelled {
                toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                toView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    

}

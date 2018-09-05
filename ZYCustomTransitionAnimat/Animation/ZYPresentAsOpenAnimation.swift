//
//  ZYPresentAsOpenAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYPresentAsOpenAnimation: ZYAnimation {
    var direction: OpenDirection
    
    init(direction d:OpenDirection) {
        direction = d
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let fromView = transitionContext.view(forKey: .from)
            else { return }
        let containerView = transitionContext.containerView
        
        toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        containerView.addSubview(toView)
        
        //用于截取图片的范围
        var rect0 = CGRect()
        var rect1 = CGRect()
        //用于动画
        var targetRect0 = CGRect()
        var targetRect1 = CGRect()
        switch direction {
        case .horizontal:
            rect0 = CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight)
            rect1 = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: screenHeight)
            targetRect0 = CGRect(x: -screenWidth/2, y: 0, width: screenWidth/2, height: screenHeight)
            targetRect1 = CGRect(x: screenWidth, y: 0, width: screenWidth/2, height: screenHeight)
        case .vertical:
            rect0 = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/2)
            rect1 = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight/2)
            targetRect0 = CGRect(x: 0, y: -screenHeight/2, width: screenWidth, height: screenHeight/2)
            targetRect1 = CGRect(x: 0, y: screenHeight, width: screenWidth, height: screenHeight/2)
        }
        let tmpImage0 = fromView.zy_snapshot().clip(rect: rect0)
        let tmpImage1 = fromView.zy_snapshot().clip(rect: rect1)
        
        let imageView0 = UIImageView(frame: rect0)
        imageView0.image = tmpImage0
        let imageView1 = UIImageView(frame: rect1)
        imageView1.image = tmpImage1
        
        containerView.addSubview(imageView0)
        containerView.addSubview(imageView1)
        
        UIView.animate(withDuration: ZYAnimation.duration+0.25, animations: {
            imageView0.frame = targetRect0
            imageView1.frame = targetRect1
        }) { (finish) in
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}

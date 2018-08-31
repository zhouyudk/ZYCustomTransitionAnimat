//
//  ZYDismissAsCloseAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYDismissAsCloseAnimation: ZYAnimation {
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
        containerView.addSubview(fromView)
        
        //用于截取图片的范围
        var rect0 = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/2)
        var rect1 = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight/2)
        //用于动画
        var startRect0 = CGRect(x: 0, y: -screenHeight/2, width: screenWidth, height: screenHeight)
        var startRect1 = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight)
        switch direction {
        case .horizontal:
            rect0 = CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight)
            rect1 = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: screenHeight)
            startRect0 = CGRect(x: -screenWidth/2, y: 0, width: screenWidth, height: screenHeight)
            startRect1 = CGRect(x: screenWidth/2, y: 0, width: screenWidth, height: screenHeight)
        case .vertical:
            rect0 = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/2)
            rect1 = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight/2)
            startRect0 = CGRect(x: 0, y: -screenHeight/2, width: screenWidth, height: screenHeight)
            startRect1 = CGRect(x: 0, y: screenHeight/2, width: screenWidth, height: screenHeight)
        }
        let tmpImage0 = toView.zy_snapshot(rect: rect0)
        let tmpImage1 = toView.zy_snapshot(rect: rect1)
        
        let imageView0 = UIImageView(image: tmpImage0)
        let imageView1 = UIImageView(image: tmpImage1)
        imageView0.frame = startRect0
        imageView1.frame = startRect1
        
        containerView.addSubview(imageView0)
        containerView.addSubview(imageView1)
        
        UIView.animate(withDuration: ZYAnimation.duration+0.25, animations: {
            imageView0.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
            imageView1.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        }) { (finish) in
            imageView0.removeFromSuperview()
            imageView1.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}

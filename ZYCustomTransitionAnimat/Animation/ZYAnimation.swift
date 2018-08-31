//
//  ZYAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 27/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

/// 动画基类，实现CAAnimationDelegate，UIViewControllerTransitioningDelegate定义对应的协议和闭包
class ZYAnimation: NSObject,UIViewControllerAnimatedTransitioning,CAAnimationDelegate {

    
    /// 统一定义 动画时长
    public static var duration:TimeInterval = 0.5

    //
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    //CAAnimationDelegate代理中执行的闭包
    var animationStartClosure:(()->Void)?
    var animationEndClosure:(()->Void)?
    
    func animationDidStart(_ anim: CAAnimation) {
        if let startClosure = animationStartClosure {
            startClosure()
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let endClosure = animationEndClosure {
            endClosure()
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ZYAnimation.duration
    }
    //子类中复写此方法
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}


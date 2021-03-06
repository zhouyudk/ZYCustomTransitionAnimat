//
//  UIViewController+ZYExtension.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 24/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

// MARK: - present&dismiss方法扩展
extension UIViewController {
    
    /// 定制present方法
    ///
    /// - Parameters:
    ///   - vc: 目标viewController
    ///   - animatType: 动画类型PresentAnimatType
    ///   - isInteractive: 是否需要交互，false则不添加手势，默认为true
    ///   - completion: present完成后的闭包
    func zy_present(_ vc:UIViewController,animatType:PresentAnimatType,isInteractive:Bool=true,completion:(()->Void)?){
        vc.transitioningDelegate = vc
        vc.modalPresentationStyle = .fullScreen
        vc.zy_presentanimatType = animatType
        if isInteractive {
            switch animatType{
            case .fold:
                break
            default:
                vc.zy_addInteractiveTransitionGesture()
            }
        }
        self.present(vc, animated: true, completion: completion)
    }
    func zy_dismiss(completion:(()->Void)?) {
        self.transitioningDelegate = self
        self.dismiss(animated: true, completion: completion)
    }
}


public enum SpreadDirection:Int {
    case left=0,right,top,bottom
}
public enum OpenDirection{
    case horizontal,vertical
}
///MARK: - 动画类型枚举
public enum PresentAnimatType{
    case circle
    case asPush
    case spread(SpreadDirection)
    case page
    case asOpen(OpenDirection)
    case asKugou
    case fold(SpreadDirection)
    var presentAnimat: UIViewControllerAnimatedTransitioning{
        get{
            switch self {
            case .circle:
                return ZYPresentCircleAnimation()
            case .asPush:
                return ZYPresentAsPushAnimation()
            case let .spread(d):
                return ZYPresentSpreadAnimation(direction: d)
            case .page:
                return ZYPresentPageAnimation()
            case let .asOpen(d):
                return ZYPresentAsOpenAnimation(direction: d)
            case .asKugou:
                return ZYPresentAsKugouAnimation()
            case let .fold(d):
                return ZYPresentFoldAnimation(direction: d)
            }
        }
    }
    
    var dismissAnimat: UIViewControllerAnimatedTransitioning{
        get{
            switch self {
            case .circle:
                return ZYDismissCircleAnimation()
            case .asPush:
                return ZYDismissAsPopAnimation()
            case let .spread(d):
                return ZYDismissSpreadAnimation(direction: d)
            case .page:
                return ZYDismissPageAnimation()
            case let .asOpen(d):
                return ZYDismissAsCloseAnimation(direction: d)
            case .asKugou:
                return ZYDismissAsKugouAnimation()
            case let .fold(d):
                return ZYDismissFoldAnimation(direction: d)
            }
        }
    }
}
    
// MARK: - 动画扩展
extension UIViewController:UIViewControllerTransitioningDelegate {
    /// 关联属性
    private struct AssociatedKeys {
        static var presentanimatType: PresentAnimatType = .asPush
        static var interactiveTransition: UIPercentDrivenInteractiveTransition? = nil
    }
    
    /// 关联属性存取方法
    public var zy_presentanimatType: PresentAnimatType {
        get{
            let type = objc_getAssociatedObject(self, &AssociatedKeys.presentanimatType) as? PresentAnimatType
            return type == nil ? .asPush : type!
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.presentanimatType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var interactiveTransition: UIPercentDrivenInteractiveTransition?{
        get{
            let transition = objc_getAssociatedObject(self, &AssociatedKeys.interactiveTransition) as? UIPercentDrivenInteractiveTransition
            return transition == nil ? nil : transition!
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.interactiveTransition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    //MARK: - 转场动画代理
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return zy_presentanimatType.presentAnimat
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return zy_presentanimatType.dismissAnimat
    }
    ///UIViewControllerTransitioningDelegate代理方法，
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition ?? nil
    }
    internal func zy_addInteractiveTransitionGesture() {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(zy_panGestureRecognizerAction(pan:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc private func zy_panGestureRecognizerAction(pan:UIPanGestureRecognizer) {
        var process = pan.translation(in: self.view).x / UIScreen.main.bounds.width
        process = min(1.0, max(0.0, process))
        switch pan.state {
        case .began:
            self.interactiveTransition = UIPercentDrivenInteractiveTransition()
            self.dismiss(animated: true, completion: nil)
        case .changed:
            self.interactiveTransition?.update(process)
        case .ended,.cancelled:
            if process > 0.3 {
                self.interactiveTransition?.finish()
            }else{
                self.interactiveTransition?.cancel()
            }
            self.interactiveTransition = nil
        default:
            break
        }
    }
}


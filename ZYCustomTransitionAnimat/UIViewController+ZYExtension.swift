//
//  UIViewController+Extension.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 24/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

extension UIViewController {
    enum PresentAnimatType{
        case circle
        case asPush
        
        var presentAnimat: UIViewControllerAnimatedTransitioning{
            get{
                switch self {
                case .circle:
                    return ZYPresentDismissCircleAnimat()
                case .asPush:
                    return ZYPresentAsPushAnimat()
                }
            }
        }
        
        var dismissAnimat: UIViewControllerAnimatedTransitioning{
            get{
                switch self {
                case .circle:
                    return ZYPresentDismissCircleAnimat()
                case .asPush:
                    return ZYDismissAsPopAnimat()
                }
            }
        }
        
        
    }
    
    struct AssociatedKeys {
        static var presentanimatType: PresentAnimatType = .asPush
    }
    var presentanimatType: PresentAnimatType {
        get{
            let type = objc_getAssociatedObject(self, &AssociatedKeys.presentanimatType) as? PresentAnimatType
            if type == nil {
                return .asPush
            }else{
                return type!
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.presentanimatType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentanimatType.presentAnimat
        //ZYPresentDismissCircleAnimat()
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentanimatType.dismissAnimat
    }
}


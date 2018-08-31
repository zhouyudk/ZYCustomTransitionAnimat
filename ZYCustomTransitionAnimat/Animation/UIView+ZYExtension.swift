//
//  UIView+ZYExtension.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

extension UIView {
    func zy_snapshot(rect:CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        UIRectClip(rect)
        self.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
}

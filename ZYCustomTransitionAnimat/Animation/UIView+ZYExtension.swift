//
//  UIView+ZYExtension.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 30/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

extension UIView {
    func zy_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
}

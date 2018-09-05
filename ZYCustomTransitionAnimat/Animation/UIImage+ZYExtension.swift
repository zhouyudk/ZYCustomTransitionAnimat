//
//  UIImage+ZYExtension.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 04/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

extension UIImage {
    func clip(rect:CGRect) -> UIImage {
        let scale = UIScreen.main.scale 
        let i = self.cgImage?.cropping(to: CGRect(x: rect.origin.x*scale, y: rect.origin.y*scale, width: rect.width*scale, height: rect.height*scale))
        return UIImage(cgImage: i!)
    }
}

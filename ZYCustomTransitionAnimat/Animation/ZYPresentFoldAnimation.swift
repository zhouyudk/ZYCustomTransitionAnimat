//
//  ZYPresentAsFoldAnimation.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 03/09/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

protocol ZYFoldDelegate {
    
}
extension ZYFoldDelegate {
    
    func transformLayerFrom(image: UIImage, frame: CGRect, duration: TimeInterval, anchorPoint: CGPoint, startAngle: Double, endAngle: Double) -> CATransformLayer {
        let jointLayer = CATransformLayer()
        jointLayer.anchorPoint = anchorPoint
        let imageLayer = CALayer()
        let shadowLayer = CAGradientLayer()
        var shadowAniOpacity: Double = 0
        
        if anchorPoint.y == 0.5 {
            var layerWidth: CGFloat = 0
            if anchorPoint.x == 0 { // from left to right
                layerWidth = image.size.width - frame.origin.x
                jointLayer.frame = CGRect(x: 0, y: 0, width: layerWidth, height: frame.size.height)
                if frame.origin.x != 0 {
                    jointLayer.position = CGPoint(x: frame.size.width, y: frame.size.height / 2)
                } else {
                    jointLayer.position = CGPoint(x: 0, y: frame.size.height / 2)
                }
            } else { // from right to left
                layerWidth = frame.origin.x + frame.size.width
                jointLayer.frame = CGRect(x: 0, y: 0, width: layerWidth, height: frame.size.height)
                jointLayer.position = CGPoint(x: layerWidth, y: frame.size.height / 2)
            }
            
            //map image onto transform layer
            imageLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            imageLayer.anchorPoint = anchorPoint
            imageLayer.position = CGPoint(x: layerWidth * anchorPoint.x, y: frame.size.height / 2)
            jointLayer.addSublayer(imageLayer)
            let scaledFrame = CGRect(x: frame.origin.x * image.scale,
                                     y: frame.origin.y * image.scale,
                                     width: frame.size.width * image.scale,
                                     height: frame.size.height * image.scale)
            let imageCrop = image.cgImage?.cropping(to: scaledFrame)
            imageLayer.contents = imageCrop
            imageLayer.backgroundColor = UIColor.clear.cgColor
            
            //add shadow
            let index = Int(frame.origin.x / frame.size.width)
            shadowLayer.frame = imageLayer.bounds
            shadowLayer.backgroundColor = UIColor.darkGray.cgColor
            shadowLayer.opacity = 0.0
            shadowLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            if index % 2 != 0 {
                shadowLayer.startPoint = CGPoint(x: 0, y: 0.5)
                shadowLayer.endPoint = CGPoint(x: 1, y: 0.5)
                shadowAniOpacity = anchorPoint.x != 0 ? 0.24 : 0.32
            } else {
                shadowLayer.startPoint = CGPoint(x: 1, y: 0.5)
                shadowLayer.endPoint = CGPoint(x: 0, y: 0.5)
                shadowAniOpacity = anchorPoint.x != 0 ? 0.32 : 0.24
            }
        } else {
            var layerHeight: CGFloat = 0
            if anchorPoint.y == 0 { // from top
                layerHeight = image.size.height - frame.origin.y
                jointLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: layerHeight)
                if frame.origin.y != 0 {
                    jointLayer.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
                } else {
                    jointLayer.position = CGPoint(x: frame.size.width / 2, y: 0)
                }
            } else { // from bottom
                layerHeight = frame.origin.y + frame.size.height
                jointLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: layerHeight)
                jointLayer.position = CGPoint(x: frame.size.width / 2, y: layerHeight)
            }
            
            // map image onto transform layer
            imageLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            imageLayer.anchorPoint = anchorPoint
            imageLayer.position = CGPoint(x: frame.size.width/2, y: layerHeight*anchorPoint.y)
            jointLayer.addSublayer(imageLayer)
            let scaledFrame = CGRect(x: frame.origin.x * image.scale,
                                     y: frame.origin.y * image.scale,
                                     width: frame.size.width * image.scale,
                                     height: frame.size.height * image.scale)
            let imageCrop = image.cgImage?.cropping(to: scaledFrame)
            imageLayer.contents = imageCrop
            imageLayer.backgroundColor = UIColor.clear.cgColor
            
            //add shadow
            let index = Int(frame.origin.y / frame.size.height)
            shadowLayer.frame = imageLayer.bounds
            shadowLayer.backgroundColor = UIColor.darkGray.cgColor
            shadowLayer.opacity = 0.0
            shadowLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            
            if index % 2 != 0 {
                shadowLayer.startPoint = CGPoint(x: 0.5, y: 0)
                shadowLayer.endPoint = CGPoint(x: 0.5, y: 1)
                shadowAniOpacity = anchorPoint.x != 0 ? 0.24 : 0.32
            } else {
                shadowLayer.startPoint = CGPoint(x: 0.5, y: 1)
                shadowLayer.endPoint = CGPoint(x: 0.5, y: 0)
                shadowAniOpacity = anchorPoint.x != 0 ? 0.32 : 0.24
            }
        }
        imageLayer.addSublayer(shadowLayer)
        
        // animate open/close animation
        var animation = CABasicAnimation(keyPath: "transform.rotation.\(anchorPoint.y == 0.5 ? "y" : "x")")
        animation.duration = duration
        animation.fromValue = startAngle
        animation.toValue = endAngle
        animation.isRemovedOnCompletion = false
        jointLayer.add(animation, forKey: "jointAnimation")
        
        // animate shadow opacity
        animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = startAngle != 0 ? shadowAniOpacity : 0
        animation.toValue = startAngle != 0 ? 0 : shadowAniOpacity
        animation.isRemovedOnCompletion = false
        shadowLayer.add(animation, forKey: nil)
        
        return jointLayer
    }
    
    /// 创建折叠layer并展开
    ///
    /// - Parameters:
    ///   - rect: foldLayer的frame
    ///   - foldView: 被折叠的view
    ///   - direction: 折叠方向
    ///   - duration: layer旋转的动画时间
    ///   - isFold: 是否为折叠，true为折叠，false为伸展
    /// - Returns: foldlayer
    func createFoldsLayer(rect:CGRect,foldView:UIView,direction:SpreadDirection,duration:TimeInterval,isFold:Bool)->CALayer {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 800.0
        let paperFoldingLayer = CALayer()
        paperFoldingLayer.frame = CGRect(origin: CGPoint.zero, size: rect.size)
        paperFoldingLayer.backgroundColor = UIColor(white: 0.2, alpha: 1).cgColor

        let folds = 3//折叠数,该参数可以为动态的
        let frameWidth = rect.size.width
        let frameHeight = rect.size.height
        let foldWidth = direction.rawValue < 2 ? frameWidth / CGFloat(folds * 2) : frameHeight / CGFloat(folds * 2)
        var prevLayer = paperFoldingLayer
        //此for循环是创建折叠动画的关键
        //其目的可以联想真正的折纸,以向右折叠为例
        //将视图裁剪为folds*2等分，如分别为A B C D,同时分别创建layerA,layerB,LayerC,LayerD,其宽度以foldWidth为差的等差数列，
        //-------A
        //--------------B
        //---------------------C
        //----------------------------D
        //依次将A添加到B, B添加到C, C添加到D，这样D旋转时会带动ABC旋转，C旋转会带动AB旋转，最后出现折纸的效果
        for b in 0 ..< folds * 2 {//被用于折叠的sublayer是折叠数的两倍，
            var rotationAngle: Double
            var anchorPoint: CGPoint
            var imageFrame: CGRect
            
            switch direction {
            case .right:
                anchorPoint = CGPoint(x: 1, y: 0.5)
                rotationAngle = b == 0 ? -Double.pi / 2 : (b % 2 != 0 ? Double.pi : -Double.pi)
                imageFrame = CGRect(x: frameWidth - CGFloat(b + 1) * foldWidth,
                                    y: 0,
                                    width: foldWidth,
                                    height: frameHeight)
            case .left:
                anchorPoint = CGPoint(x: 0, y: 0.5)
                rotationAngle = b == 0 ? Double.pi / 2 : (b % 2 != 0 ? -Double.pi : Double.pi)
                imageFrame = CGRect(x: CGFloat(b) * foldWidth,
                                    y: 0,
                                    width: foldWidth,
                                    height: frameHeight)
            case .top:
                anchorPoint = CGPoint(x: 0.5, y: 0)
                rotationAngle = b == 0 ? -Double.pi / 2 : (b % 2 != 0 ? Double.pi : -Double.pi)
                imageFrame = CGRect(x: 0,
                                    y: CGFloat(b) * foldWidth,
                                    width: frameWidth,
                                    height: foldWidth)
            case .bottom:
                anchorPoint = CGPoint(x: 0.5, y: 1)
                rotationAngle = b == 0 ? Double.pi / 2 : (b % 2 != 0 ? -Double.pi : Double.pi)
                imageFrame = CGRect(x: 0,
                                    y: frameHeight - CGFloat(b + 1) * foldWidth,
                                    width: frameWidth,
                                    height: foldWidth)
            }

            //rotationAngle,当展开时为起始值，当折叠时为结束值
            let startAngle = isFold ? 0 : rotationAngle
            let endAngle = isFold ? rotationAngle : 0
            let transLayer = self.transformLayerFrom(image: foldView.zy_snapshot(), frame: imageFrame, duration: duration, anchorPoint: anchorPoint, startAngle: startAngle, endAngle: endAngle)
            prevLayer.addSublayer(transLayer)
            prevLayer = transLayer
        }
        return paperFoldingLayer
    }
}

extension CAKeyframeAnimation {
    static func animationWith(keyPath path: String, function block: ((CGFloat)->CGFloat), fromValue: CGFloat, toValue: CGFloat) -> CAKeyframeAnimation {
        
        // get a keyframe animation to set up
        let animation = CAKeyframeAnimation(keyPath: path)
        // break the time into steps (the more steps, the smoother the animation)
        let steps = 100
        var values: [CGFloat] = []
        var time: CGFloat = 0.0
        let timeStep = 1.0 / CGFloat(steps - 1)
        for _ in 0 ..< steps {
            let value = fromValue + block(time) * (toValue - fromValue)
            values.append(value)
            time += timeStep
        }
        // we want linear animation between keyframes, with equal time steps
        animation.calculationMode = CAAnimationCalculationMode.linear
        // set keyframes and we're done
        animation.values = values
        return animation
    }
}

class ZYPresentFoldAnimation: ZYAnimation,ZYFoldDelegate {
    var direction: SpreadDirection
    
    init(direction d:SpreadDirection) {
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
        
        let paperFoldingLayer = self.createFoldsLayer(rect: containerView.frame, foldView: toView, direction: direction, duration: ZYAnimation.duration+0.5,isFold: false)
        containerView.layer.addSublayer(paperFoldingLayer)
        containerView.addSubview(fromView)//fromView必须在paperFoldingLayer之后添加，否则会遮挡
        //对fromView进行位移
        let openFunction: ((CGFloat) -> CGFloat) = { (time) in
            return sin(time * CGFloat.pi / 2)
        }
        var openAnimation: CAKeyframeAnimation!
        var fromValue: CGFloat
        var toValue: CGFloat
        var keyPath: String
        switch direction {
        case .right:
            keyPath = "position.x"
            fromValue = fromView.frame.size.width / 2
            toValue = -fromView.frame.size.width / 2
        case .left:
            keyPath = "position.x"
            fromValue = fromView.frame.size.width / 2
            toValue =  fromView.frame.size.width+fromView.frame.size.width / 2
        case .top:
            keyPath = "position.y"
            fromValue = fromView.frame.size.height / 2
            toValue = fromView.frame.size.height+fromView.frame.size.height / 2
        case .bottom:
            keyPath = "position.y"
            fromValue = fromView.frame.size.height / 2
            toValue = -fromView.frame.size.height / 2
        }
        
        openAnimation = CAKeyframeAnimation.animationWith(keyPath: keyPath,
                                                          function: openFunction,
                                                          fromValue: fromValue,
                                                          toValue: toValue)
        openAnimation.fillMode = CAMediaTimingFillMode.forwards
        openAnimation.isRemovedOnCompletion = false
        openAnimation.duration = ZYAnimation.duration+0.5
        openAnimation.delegate = self
        fromView.layer.add(openAnimation, forKey: "position")
        
        self.animationEndClosure = {
            fromView.frame = containerView.frame
            paperFoldingLayer.removeFromSuperlayer()
            fromView.layer.removeAllAnimations()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    
}

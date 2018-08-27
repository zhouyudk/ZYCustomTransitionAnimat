//
//  ZYSecondViewController.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 22/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYSecondViewController: UIViewController,UIViewControllerTransitioningDelegate,UINavigationControllerDelegate {
    var interactiveTransition:UIPercentDrivenInteractiveTransition!//dismiss交互动画
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transitioningDelegate = self
        addInteractiveTransitionGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonHandle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentanimatType.presentAnimat
        //ZYPresentDismissCircleAnimat()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentanimatType.dismissAnimat
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactiveTransition
    }
    
    func addInteractiveTransitionGesture() {
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panGestureRecognizerAction(pan:)))
        self.view.addGestureRecognizer(pan)
    }
    
    @objc func panGestureRecognizerAction(pan:UIPanGestureRecognizer) {
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

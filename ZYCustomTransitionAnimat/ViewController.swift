//
//  ViewController.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 21/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func presentAnimat(_ sender: Any) {
        let vc = ZYSecondViewController()
        vc.transitioningDelegate = vc
        vc.presentanimatType = .circle
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func pushButtonHandle(_ sender: Any) {
        let vc = ZYSecondViewController()
        vc.transitioningDelegate = vc
        vc.presentanimatType = .asPush
        self.present(vc, animated: true, completion: nil)
    }
}


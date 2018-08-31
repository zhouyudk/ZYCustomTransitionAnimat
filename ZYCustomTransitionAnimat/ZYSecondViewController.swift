//
//  ZYSecondViewController.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 22/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ZYSecondViewController: UIViewController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonHandle(_ sender: Any) {
//        self.zy_dismiss(completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

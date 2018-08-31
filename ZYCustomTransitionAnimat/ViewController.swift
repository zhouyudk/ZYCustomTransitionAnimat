//
//  ViewController.swift
//  ZYCustomTransitionAnimat
//
//  Created by yu zhou on 21/08/2018.
//  Copyright © 2018 yu zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let dataSource = ["Circle","AsPush","SpreadFromleft","SpreadFromRight","SpreadFromTop","SpreadFromBottom","Page","AsHorizontalOpen","AsVerticalOpen"]
    let animatTypes:[PresentAnimatType] =  [.circle,.asPush,.spread(.left),.spread(.right),.spread(.top),.spread(.bottom),.page,.asOpen(.horizontal),.asOpen(.vertical)]
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - TableDelegate & TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else { return UITableViewCell() }
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.zy_present(ZYSecondViewController(), animatType: animatTypes[indexPath.row], completion: nil)
//        self.present(ZYSecondViewController(), animated: true, completion: nil)
    }
    
}


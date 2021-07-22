////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit

class setting: UIViewController {
    var little_data_center:UserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        little_data_center = UserDefaults.init()
        little_data_center?.setValue(120, forKey: "canHoldSecond")
        // Do any additional setup after loading the view.
    }

}


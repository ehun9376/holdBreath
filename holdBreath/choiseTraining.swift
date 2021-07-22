////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit

class choiseTraining: UIViewController {
    var little_data_center:UserDefaults?
    @IBAction func co2Btn(_ sender: UIButton) {
        little_data_center!.set(0, forKey: "userChoise")
        
    }
    @IBAction func o2Btn(_ sender: UIButton) {
        little_data_center!.set(1, forKey: "userChoise")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        little_data_center = UserDefaults.init()
        // Do any additional setup after loading the view.
    }


}


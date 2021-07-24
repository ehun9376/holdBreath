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
        if little_data_center?.integer(forKey: "ever") != 1{
            let alert = UIAlertController(title: "通知", message: "這是你的第一次開啟應用程式，請先查看使用資訊", preferredStyle: .alert)
            let button = UIAlertAction(title: "ok", style: .default) { button in
                //從storyboard取得ID為InfoViewController的類別，並初始化
                let infoVC = self.storyboard?.instantiateViewController(identifier: "infoVC") as? info
                //顯示資訊
                self.show(infoVC!, sender: nil)
                self.little_data_center?.setValue(1, forKey: "ever")
                }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
        }
        
        // Do any additional setup after loading the view.
    }


}


////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit
import UserNotifications
class SettingViewController: UIViewController {
    
    var maxTime = 0 {
        didSet {
            UserInfoCenter.shared.storeValue(.canHoldSecond, data: self.maxTime)
        }
    }
    
    @IBAction func gotoBuyTimes(_ sender: UIButton) {
        
        IAPCenter.shared.getProducts {
            DispatchQueue.main.async {
                let vc = SelectViewController()
                
                var codeDataSource: [CodeModel] = []
                
                                
                let buyedTypes = IAPCenter.shared.buyTypes
                
                for (index,type) in buyedTypes.enumerated() {
                    codeDataSource.append(CodeModel(text: type.title, number: index, data: type))
                }
                
                vc.dataSourceModels = codeDataSource
                
                self.present(vc, animated: true)
            }

        }
        

        
        
    }
    
    @IBOutlet weak var labelSetTime: UILabel!
    
    @IBAction func btnTimeDown(_ sender: UIButton) {
        self.sliderTimeOutlet.value -= 1
        self.maxTime -= 1
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)

    }
    @IBAction func btnTimeUP(_ sender: UIButton) {
        self.sliderTimeOutlet.value += 1
        self.maxTime += 1
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
    }
    
    @IBOutlet weak var switchOulet: UISwitch!
    
    @IBAction func switchNotif(_ sender: UISwitch) {
        if sender.isOn && UserInfoCenter.shared.loadValue(.notifWeek) as? [[String : String]] ?? [] != []{
            UserInfoCenter.shared.storeValue(.openNotification, data: 1)
            LocalNotificationCenter.shared.regisNotificationDate()
        } else {
            UserInfoCenter.shared.storeValue(.openNotification, data: 0)
            LocalNotificationCenter.shared.cancelNofification()
        }
    }
    @IBOutlet weak var sliderTimeOutlet: UISlider!
    
    @IBAction func sliderSetTime(_ sender: UISlider) {
        self.maxTime = Int(sender.value)
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
    }
    
    @IBAction func btnTrainingNotifcation(_ sender: UIButton) {
        let noTifVC = self.storyboard?.instantiateViewController(identifier: "noTif") as? SetNotifcationViewController
        self.show(noTifVC!, sender: nil)
        
    }
    
    @IBAction func btninfo(_ sender: UIButton) {
        let infoVC = self.storyboard?.instantiateViewController(identifier: "infoVC") as? InfoViewController
        self.show(infoVC!, sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxTime = UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
        self.sliderTimeOutlet.value = Float(self.maxTime)
        
        if (UserInfoCenter.shared.loadValue(.openNotification) as? Int ?? 0) == 0{
            self.switchOulet.isOn = false
        } else {
            self.switchOulet.isOn = true
        }
        

    }
    
}


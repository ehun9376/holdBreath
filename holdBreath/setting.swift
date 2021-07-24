////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit
import UserNotifications
class setting: UIViewController {
    var little_data_center:UserDefaults?
    var maxTime = 0
    var weekday:[[String:String]]?
    var notifsignal = 0
    @IBOutlet weak var labelSetTime: UILabel!
    
    @IBAction func btnTimeDown(_ sender: UIButton) {
        self.sliderTimeOutlet.value -= 1
        self.maxTime -= 1
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
//        little_data_center?.setValue(self.maxTime, forKey: "canHoldSecond")
    }
    @IBAction func btnTimeUP(_ sender: UIButton) {
        self.sliderTimeOutlet.value += 1
        self.maxTime += 1
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
    }
    
    @IBOutlet weak var switchOulet: UISwitch!
    @IBAction func switchNotif(_ sender: UISwitch) {
        
        if sender.isOn{
            let content = UNMutableNotificationContent()
            content.title = "推波測試"
            content.badge = 3
            content.sound = .default
            content.categoryIdentifier = "trainningNotif"
            var date = DateComponents()
            date.month = 7
            date.day = 24
            date.hour = 9
            date.minute = 43
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let request = UNNotificationRequest(identifier: "trainningNotif", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            little_data_center?.setValue(1, forKey: "openNotif")
            print("開關打開")
        }
        else{
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            little_data_center?.setValue(0, forKey: "openNotif")
            print("開關關閉")
        }
    }
    @IBOutlet weak var sliderTimeOutlet: UISlider!
    @IBAction func sliderSetTime(_ sender: UISlider) {
        self.maxTime = Int(sender.value)
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
//        little_data_center?.setValue(self.maxTime, forKey: "canHoldSecond")
    }
    @IBAction func btnTrainingNotifcation(_ sender: UIButton) {
        let noTifVC = self.storyboard?.instantiateViewController(identifier: "noTif") as? notifcationVC
        self.show(noTifVC!, sender: nil)
        
    }
    @IBAction func btninfo(_ sender: UIButton) {
        let infoVC = self.storyboard?.instantiateViewController(identifier: "infoVC") as? info
        self.show(infoVC!, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        little_data_center = UserDefaults.init()
        self.maxTime = little_data_center?.integer(forKey: "canHoldSecond") ?? 0
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
        self.sliderTimeOutlet.value = Float(self.maxTime)
        self.notifsignal = little_data_center?.integer(forKey: "openNotif") ?? 0
        if self.notifsignal == 0{
            self.switchOulet.isOn = false
        }else{
            self.switchOulet.isOn = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("使用者秒數\(self.maxTime)以紀錄")
        little_data_center?.setValue(self.maxTime, forKey: "canHoldSecond")

    }
    
}


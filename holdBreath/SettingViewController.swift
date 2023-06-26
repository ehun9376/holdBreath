////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit
import UserNotifications
class SettingViewController: UIViewController {
    var homeDataCenter:UserDefaults?
    
    var maxTime = 0 {
        didSet {
            homeDataCenter?.setValue(self.maxTime, forKey: "canHoldSecond")
        }
    }
    
    var weekday:[[String:String]]?
    
    var setTime:[String]?
    
    var notifsignal = 0
    
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
        if sender.isOn && self.weekday != []{
            print("通知設定區")
            for (n,day) in self.weekday!.enumerated(){
                if day["check"] == "true"{
                    let content = UNMutableNotificationContent()
                    content.title = "準備開始訓練了"
                    content.badge = 1
                    content.sound = .default
                    var date = DateComponents()
                    date.weekday = n+1
                    date.hour = Int(self.setTime![0])
                    date.minute = Int(self.setTime![1])
                    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                    let request = UNNotificationRequest(identifier: "week\(date.weekday!)", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    print(trigger)
                }
            }
            homeDataCenter?.setValue(1, forKey: "openNotif")
        }
        else{
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            homeDataCenter?.setValue(0, forKey: "openNotif")
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.weekday = homeDataCenter?.array(forKey: "weekNotif") as? [[String : String]] ?? []
        self.setTime = self.homeDataCenter?.string(forKey: "timeNotif")?.components(separatedBy: ":") ?? []
        print(self.weekday!)
        print(self.setTime!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        homeDataCenter = UserDefaults.init()
        self.maxTime = homeDataCenter?.integer(forKey: "canHoldSecond") ?? 0
        self.labelSetTime.text = String(format: "%02d:%02d", self.maxTime / 60, self.maxTime % 60)
        self.sliderTimeOutlet.value = Float(self.maxTime)
        self.notifsignal = homeDataCenter?.integer(forKey: "openNotif") ?? 0
        if self.notifsignal == 0{
            self.switchOulet.isOn = false
        }else{
            self.switchOulet.isOn = true
        }
        

    }
    
}


//
//  LocalNotificationCenter.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2023/6/26.
//

import Foundation
import UserNotifications

class LocalNotificationCenter: NSObject {
    static let shared = LocalNotificationCenter()
    
    func regisNotificationDate() {
        for (n,day) in (UserInfoCenter.shared.loadValue(.notifWeek) as? [[String : String]] ?? []).enumerated(){
            if day["check"] == "true"{
                let content = UNMutableNotificationContent()
                content.title = "準備開始訓練了"
                content.badge = 1
                content.sound = .default
                var date = DateComponents()
                date.weekday = n+1
                let time = (UserInfoCenter.shared.loadValue(.notifTime) as? String ?? "00:00").components(separatedBy: ":")
                date.hour = Int(time[0])
                date.minute = Int(time[1])
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let request = UNNotificationRequest(identifier: "week\(date.weekday!)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                print(trigger)
            }
        }
    }
    
    func cancelNofification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}



//
//  UserDefaultCenter.swift
//  BlackSreenVideo
//
//  Created by yihuang on 2022/11/23.
//

import Foundation
import UIKit



class UserInfoCenter: NSObject {
    
    static let shared = UserInfoCenter()
    
    enum UserInfoDataType: String, CaseIterable {
        
        // 打開訓練提醒
        case openNotification
        
        //最高可以閉氣息多久
        case canHoldSecond
        
        //有沒有開過
        case ever
        
        //使用者選了什麼訓練
        case userChoise
        
        //通知的時間
        case notifTime
        
        //通知的日期
        case notifWeek
    }
    
    func storeValue(_ type: UserInfoDataType, data: Any?) {
        UserDefaults.standard.set(data, forKey: type.rawValue)
    }
    
    func loadValue(_ type: UserInfoDataType) -> Any? {
        if let something = UserDefaults.standard.object(forKey: type.rawValue) {
            return something
        } else {
            return nil
        }
    }
    
    func cleanValue(_ type: UserInfoDataType) {
        UserDefaults.standard.removeObject(forKey: type.rawValue)
    }
    
    func storeData<T: Codable>(model: T, _ type: UserInfoDataType) {
        
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(model)
            UserDefaults.standard.set(data, forKey: type.rawValue)
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func loadData<T: Codable>(modelType: T.Type, _ type: UserInfoDataType) -> T? {
        let decoder = JSONDecoder()
        
        do {
            if let data = UserInfoCenter.shared.loadValue(type) as? Data {
                let model = try decoder.decode(modelType, from: data)
                return model
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
        
    }
    
    func cleanAll() {
        for type in UserInfoDataType.allCases {
            self.cleanValue(type)
        }
    }
    
 
    
}

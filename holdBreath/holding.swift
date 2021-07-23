////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit
import AVFoundation
class holding: UIViewController,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    var signal = 0
    var holdtime = 0
    var everytime = ["15","30","60"]
    var currentObjectBottomYPosition :CGFloat!
    weak var timer:Timer!
    var audioplayer:AVAudioPlayer!
    var homeDataCenter:UserDefaults?
    var recordArray:[[String:String]]?
    var historyBestRecord = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    let fullScreenSize = UIScreen.main.bounds.size
    var pickView:UIPickerView?
    var dateString:String?
    @IBOutlet weak var switchHistory: UISwitch!
    @IBOutlet weak var switchEverysecond: UISwitch!
    @IBOutlet weak var labelBest: UILabel!
    @IBOutlet weak var textEverySecond: UITextField!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var labelHiostoryTime: UILabel!
    @IBOutlet weak var tableHistory: UITableView!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBAction func buttonStart(_ sender: UIButton) {
        //start開始時計時器就會跳時間
        //先倒數10秒再開始正數
        if signal == 0 {
            signal = 1
            sender.setTitle("Stop", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countUP), userInfo: nil, repeats: true)
            //播放聲音倒數十秒後開始
            audioplayer.play()
            self.switchHistory.isHidden = true
            self.switchEverysecond.isHidden = true
        }
        //結束時自動記錄時間並上傳至userdefault
        else{
            signal = 0
            self.switchHistory.isHidden = false
            self.switchEverysecond.isHidden = false
            sender.setTitle("Start", for: .normal)
            timer.invalidate()
            print("紀錄是\(holdtime)")
            self.recordArray?.append(["date":"\(self.dateString!)","record":"\(holdtime)"])
            homeDataCenter!.setValue(self.recordArray, forKey: "record")
//            self.prepareTime = 10
            self.labelCurrentTime.text = String(format:"00:00")
            if self.recordArray?.contains([:]) == true{
                self.recordArray?.remove(at: 0)
            }
            if self.recordArray != [[:]]{
                for record in self.recordArray! {
                    if record == [:]{
                        break
                    }
                    if Int(record["record"]!)! > self.historyBestRecord{
                        self.historyBestRecord = Int(record["record"]!)!
                    }
                }
            }
            self.holdtime = 0
            self.labelBest.text = String(format: "%02d:%02d", self.historyBestRecord / 60, self.historyBestRecord  % 60)
            self.tableHistory.reloadData()
        }
        
    }
    @IBAction func switchHistory(_ sender: UISwitch) {
    }
    @IBAction func switchSecond(_ sender: UISwitch) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //audioPlayer區
        do{
            self.audioplayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "holdBreath", withExtension: "mp3")!)
        }
        catch{
            print("音樂載入錯誤\(error)")
        }
        homeDataCenter = UserDefaults.init()
        recordArray = homeDataCenter?.array(forKey: "record") as? [[String:String]] ?? [[:]]
        print(recordArray!)
        dateFormatter.dateFormat = "yyyy/MM/dd "
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        dateString = dateFormatter.string(from: date)
//        print(dateString!)
        if self.recordArray != [[:]]{
            for record in self.recordArray! {
                if record == [:]{
                    break
                }
                if Int(record["record"]!)! > self.historyBestRecord{
                    self.historyBestRecord = Int(record["record"]!)!
                }
            }
        }
        self.labelBest.text = String(format: "%02d:%02d", self.historyBestRecord / 60, self.historyBestRecord  % 60)
        self.tableHistory.dataSource = self
        self.tableHistory.delegate = self
        self.tableHistory.rowHeight = 100
        self.tableHistory.reloadData()
        self.pickView = UIPickerView(frame: CGRect(x: 0, y: fullScreenSize.height * 0.3, width: fullScreenSize.width, height: 150))
        self.pickView?.delegate = self
        self.pickView?.dataSource = self
        self.textEverySecond.inputView = self.pickView
    }
    @objc func countUP(){
            //播放聲音開始計時
            self.holdtime += 1
            self.labelCurrentTime.text = String(format: "%02d:%02d", self.holdtime / 60, self.holdtime  % 60)
        if self.switchHistory.isOn == true{
            if self.holdtime == historyBestRecord + 1{
                do{
                    self.audioplayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "moreThenPB", withExtension: "mp3")!)
                }
                catch{
                    print("音樂載入錯誤\(error)")
                }
                self.audioplayer.play()
            }
            if self.switchEverysecond.isOn == true && self.textEverySecond != nil{
                if holdtime % Int(self.textEverySecond.text!)! == 0 {
                    print("經過設定時間")
                    do{
                        self.audioplayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "ding", withExtension: "mp3")!)
                    }
                    catch{
                        print("音樂載入錯誤\(error)")
                    }
                    self.audioplayer.play()
                }
            }
        }
            print("開始正數\(holdtime)")
    }
    //table函數區
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //有幾個紀錄
        return self.recordArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //每個紀錄中的數字，左邊日期，右邊時間
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "mycell")
        if self.recordArray != [[:]]{
            
            cell.textLabel?.text = String(format: "%02d:%02d", Int(self.recordArray!.reversed()[indexPath.row]["record"]!)! / 60, Int(self.recordArray!.reversed()[indexPath.row]["record"]!)!  % 60)
            cell.detailTextLabel?.text = self.recordArray!.reversed()[indexPath.row]["date"]
        }
        else{
            cell.textLabel?.text = "目前還沒有紀錄"
        }
        
        cell.detailTextLabel?.textColor = UIColor.black
        return cell
        
    }
    
    //pickView函數區
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.everytime.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.everytime[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textEverySecond.text = self.everytime[row]
        self.view.endEditing(true)
        
    }
}


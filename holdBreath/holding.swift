////
//  ViewController.swift
//  holdBreath
//
//  Created by 陳逸煌 on 2021/7/19.
//

import UIKit
import AVFoundation
class holding: UIViewController,UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate {

    var signal = 0
    var holdtime = 0
//    var prepareTime = 10
    weak var timer:Timer!
    var audioplayer:AVAudioPlayer!
    var homeDataCenter:UserDefaults?
    var recordArray:[[String:String]]?
    var historyBestRecord = 0
    let date = Date()
    let dateFormatter = DateFormatter()
    var dateString:String?
    @IBOutlet weak var switchHistory: UISwitch!
    @IBOutlet weak var switchEverysecond: UISwitch!
    @IBOutlet weak var labelBest: UILabel!
    @IBOutlet weak var labelEverySecond: UITextField!
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
            self.labelBest.text = String(format: "%02d:%02d", self.historyBestRecord / 60, self.historyBestRecord  % 60)
            self.tableHistory.reloadData()
        }
        
    }
    @IBAction func switchHistory(_ sender: UISwitch) {
        //切換要不要在到達歷史最佳紀錄時提醒
        if sender.isOn == true{
            if self.holdtime == self.historyBestRecord{
                print("達到歷史最佳")
            }
        }
    }
    @IBAction func switchSecond(_ sender: UISwitch) {
        //每幾秒提醒使用者
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
    }
    @objc func countUP(){
//        if prepareTime >= 0 {
//            if prepareTime == 0{
//                do{
//                    self.audioplayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "holdBreath", withExtension: "mp3")!)
//                }
//                catch{
//                    print("音樂載入錯誤\(error)")
//                }
//                self.audioplayer.play()
//            }
//            print("開始倒數\(prepareTime)")
//            self.labelCurrentTime.text = String(format: "%02d:%02d", self.prepareTime / 60, self.prepareTime  % 60)
//            prepareTime -= 1
//        }
        
            //播放聲音開始計時
            self.holdtime += 1
            self.labelCurrentTime.text = String(format: "%02d:%02d", self.holdtime / 60, self.holdtime  % 60)
            print("開始正數\(holdtime)")
        

    }
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
}


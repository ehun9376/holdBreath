import UIKit
import AVFoundation
class training: UIViewController,AVAudioPlayerDelegate {
    var choiseNumber = 0
    var little_data_center:UserDefaults?
    var breathSecond = 150
    var count = 0
    var holdSecond = 0
    var breathPlayer:AVAudioPlayer!
    var holdPlayer:AVAudioPlayer!
    var donePlayer:AVAudioPlayer!
    var realHoldSecond = 0
    var x = 33
    weak var totalTimer:Timer!
    var totaltime = 0
    @IBOutlet weak var breath1: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var breath2: UILabel!
    @IBOutlet weak var breath3: UILabel!
    @IBOutlet weak var breath4: UILabel!
    @IBOutlet weak var breath5: UILabel!
    @IBOutlet weak var breath6: UILabel!
    @IBOutlet weak var breath7: UILabel!
    @IBOutlet weak var breath8: UILabel!
    @IBOutlet weak var hold1: UILabel!
    @IBOutlet weak var hold2: UILabel!
    @IBOutlet weak var hold3: UILabel!
    @IBOutlet weak var hold4: UILabel!
    @IBOutlet weak var hold5: UILabel!
    @IBOutlet weak var hold6: UILabel!
    @IBOutlet weak var hold7: UILabel!
    @IBOutlet weak var hold8: UILabel!
    @IBOutlet var breathCollevtion: [UILabel]!
    @IBOutlet var holdCollection: [UILabel]!
    
    @IBOutlet weak var startbtnOulet: UIButton!
    @IBAction func startbtn(_ sender: UIButton) {
        if choiseNumber == 0{
            //二氧化碳訓練區
            if count == 0 {
                        sender.setTitle("Stop", for: .normal)
                        count += 1
                        totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(co2CountDown), userInfo: nil, repeats: true)
                        breathPlayer.play()
                    }
                    else{
                        sender.setTitle("Start", for: .normal)
                        totalTimer.invalidate()
                        count = 0
                        breathSecond = 150
                        holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                        print(holdSecond)
                        for breath in breathCollevtion{
                            breath.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
                            breathSecond -= 15
                            }
                            breathSecond = 150
                        for hold in holdCollection{
                            hold.text = String(format: "%02d:%02d", holdSecond / 60, holdSecond % 60)
                        }
                    }
        }
        if choiseNumber == 1{
            //氧氣訓練O2區
            if count == 0 {
                        sender.setTitle("Stop", for: .normal)
                        count += 1
                        totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(O2CountDown), userInfo: nil, repeats: true)
                        breathPlayer.play()
                    }
                    else{
                        sender.setTitle("Start", for: .normal)
                        totalTimer.invalidate()
                        count = 0
                        breathSecond = 120
                        holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!)
                        for breath in breathCollevtion{
                            breath.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
                            }
                        for hold in holdCollection{
                            if x > 81{
                                x = 81
                            }
                            realHoldSecond = (holdSecond * x / 100) + 2
                            hold.text = String(format: "%02d:%02d", realHoldSecond / 60, realHoldSecond  % 60)
                            x+=8
                        }
                        self.realHoldSecond = 0
                        self.x = 33
                    }
        }
        


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        little_data_center = UserDefaults.init()
        if Int((little_data_center?.integer(forKey: "canHoldSecond"))!) == 0{
            let alert = UIAlertController(title: "通知", message: "這是你的第一次訓練，請先至設定頁面設定時間", preferredStyle: .alert)
            let button = UIAlertAction(title: "ok", style: .default) { button in
                self.navigationController?.popViewController(animated: true)
                print("離開訓練頁面")
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
        }
        self.choiseNumber = (little_data_center?.integer(forKey: "userChoise"))!
        do{
            breathPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "breath", withExtension: "mp3")!)
            holdPlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "holdBreath", withExtension: "mp3")!)
            donePlayer = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "done", withExtension: "mp3")!)
        }
        catch{
            print("音樂載入錯誤\(error)")
        }
        switch choiseNumber {
        case 0:
            for breath in breathCollevtion{
                if breathSecond <= 60 {
                    breathSecond = 60
                }
                breath.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
                totaltime += breathSecond
                breathSecond -= 15
                
            }
            breathSecond = 150
            holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
            for hold in holdCollection{
                hold.text = String(format: "%02d:%02d", holdSecond / 60, holdSecond  % 60)
                totaltime += holdSecond
            }
            self.totalTimeLabel.text = String(format: "%02d:%02d", totaltime / 60, totaltime  % 60)
        case 1:
            breathSecond = 120
            for breath in breathCollevtion{
                breath.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
                totaltime += breathSecond
            }
            holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!)
            for hold in holdCollection{
                if x > 81{
                    x = 81
                }
                realHoldSecond = (holdSecond * x / 100) + 2
                hold.text = String(format: "%02d:%02d", realHoldSecond / 60, realHoldSecond  % 60)
                x+=8
                totaltime += realHoldSecond
            }
            self.totalTimeLabel.text = String(format: "%02d:%02d", totaltime / 60, totaltime  % 60)
            realHoldSecond = 0
            x = 33
        default:
            print("aaa")
        }
    }
    @objc func co2CountDown(){
        switch count {
        case 1:
            print("呼吸1倒數中")
            breathSecond -= 1
            breath1.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdPlayer.play()
            }
        case 2:
            print("閉氣1倒數中")
            self.holdSecond -= 1
            self.hold1 .text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 135
                breathPlayer.play()
            }
        case 3:
            print("呼吸2倒數中")
            breathSecond -= 1
            breath2.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 4:
            print("閉氣2倒數中")
            self.holdSecond -= 1
            self.hold2 .text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
            }
        case 5:
            print("呼吸3倒數中")
            breathSecond -= 1
            breath3.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 6:
            print("閉氣3倒數中")
            self.holdSecond -= 1
            self.hold3 .text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 105
                breathPlayer.play()
            }
        case 7:
            print("呼吸4倒數中")
            breathSecond -= 1
            breath4.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 8:
            print("閉氣4倒數中")
            self.holdSecond -= 1
            self.hold4.text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 90
                breathPlayer.play()
            }
        case 9:
            print("呼吸5倒數中")
            breathSecond -= 1
            breath5.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 10:
            print("閉氣5倒數中")
            self.holdSecond -= 1
            self.hold5 .text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 75
                breathPlayer.play()
            }
        case 11:
            print("呼吸6倒數中")
            breathSecond -= 1
            breath6.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 12:
            print("閉氣6倒數中")
            self.holdSecond -= 1
            self.hold6.text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 60
                breathPlayer.play()
            }
        case 13:
            print("呼吸7倒數中")
            breathSecond -= 1
            breath7.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 14:
            print("閉氣7倒數中")
            self.holdSecond -= 1
            self.hold7.text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 60
                breathPlayer.play()
            }
        case 15:
            print("呼吸7倒數中")
            breathSecond -= 1
            breath8.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                holdSecond = Int((little_data_center?.integer(forKey: "canHoldSecond"))!) / 2
                holdPlayer.play()
            }
        case 16:
            print("閉氣8倒數中")
            self.holdSecond -= 1
            self.hold8.text = String(format: "%02d:%02d", self.holdSecond / 60 , self.holdSecond % 60)
            if self.holdSecond == 0 {
                totalTimer.invalidate()
                self.startbtnOulet.setTitle("Start", for: .normal)
                donePlayer.play()
            }
        default:
            print("撰寫中")
        }
        
    }
    @objc func O2CountDown(){
        switch count {
        case 1:
            breathSecond -= 1
            print("呼吸1倒數中\(breathSecond)")
            breath1.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 33 / 100) + 2
                holdPlayer.play()
            }
        case 2:
            self.realHoldSecond -= 1
            print("閉氣1倒數中\(self.realHoldSecond)")
            self.hold1.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
            }
        case 3:
            breathSecond -= 1
            print("呼吸2倒數中\(breathSecond)")
            breath2.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 41 / 100) + 2
                holdPlayer.play()
            }
        case 4:
            self.realHoldSecond -= 1
            print("閉氣2倒數中\(self.realHoldSecond)")
            self.hold2.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        case 5:
            breathSecond -= 1
            print("呼吸3倒數中\(breathSecond)")
            breath3.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 49 / 100) + 2
                holdPlayer.play()
            }
        case 6:
            self.realHoldSecond -= 1
            print("閉氣3倒數中\(self.realHoldSecond)")
            self.hold3.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        case 7:
            breathSecond -= 1
            print("呼吸4倒數中\(breathSecond)")
            breath4.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 57 / 100) + 2
                holdPlayer.play()
            }
        case 8:
            self.realHoldSecond -= 1
            print("閉氣4倒數中\(self.realHoldSecond)")
            self.hold4.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        case 9:
            breathSecond -= 1
            print("呼吸5倒數中\(breathSecond)")
            breath5.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 65 / 100) + 2
                holdPlayer.play()
            }
        case 10:
            self.realHoldSecond -= 1
            print("閉氣5倒數中\(self.realHoldSecond)")
            self.hold5.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        case 11:
            breathSecond -= 1
            print("呼吸6倒數中\(breathSecond)")
            breath6.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 73 / 100) + 2
                holdPlayer.play()
            }
        case 12:
            self.realHoldSecond -= 1
            print("閉氣6倒數中\(self.realHoldSecond)")
            self.hold6.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        case 13:
            breathSecond -= 1
            print("呼吸7倒數中\(breathSecond)")
            breath7.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 81 / 100) + 2
                holdPlayer.play()
            }
        case 14:
            self.realHoldSecond -= 1
            print("閉氣7倒數中\(self.realHoldSecond)")
            self.hold7.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        case 15:
            breathSecond -= 1
            print("呼吸8倒數中\(breathSecond)")
            breath8.text = String(format: "%02d:%02d", breathSecond / 60 , breathSecond % 60)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 81 / 100) + 2
                holdPlayer.play()
            }
        case 16:
            self.realHoldSecond -= 1
            print("閉氣8倒數中\(self.realHoldSecond)")
            self.hold8.text = String(format: "%02d:%02d", self.realHoldSecond / 60 , self.realHoldSecond % 60)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer.play()
                
            }
        default:
            print("撰寫中")
        }
        
    }
}


import UIKit
import AVFoundation
class TrainingViewController: UIViewController,AVAudioPlayerDelegate {
    var choiseNumber = 0
    var breathSecond = 150
    var count = 0
    var holdSecond = 0
    var breathPlayer: AVAudioPlayer?
    var holdPlayer: AVAudioPlayer?
    var donePlayer: AVAudioPlayer?
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
                breathPlayer?.play()
            } else {
                sender.setTitle("Start", for: .normal)
                totalTimer.invalidate()
                count = 0
                breathSecond = 150
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                for breath in breathCollevtion{
                    breath.text = self.timeFormat(breathSecond)
                    breathSecond -= 15
                }
                breathSecond = 150
                for hold in holdCollection{
                    hold.text = self.timeFormat(holdSecond)
                }
            }
        } else if choiseNumber == 1{
            //氧氣訓練O2區
            if count == 0 {
                sender.setTitle("Stop", for: .normal)
                count += 1
                totalTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(O2CountDown), userInfo: nil, repeats: true)
                breathPlayer?.play()
            }
            else{
                sender.setTitle("Start", for: .normal)
                totalTimer.invalidate()
                count = 0
                breathSecond = 120
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0)
                for breath in breathCollevtion{
                    breath.text = self.timeFormat(breathSecond)
                }
                for hold in holdCollection{
                    if x > 81{
                        x = 81
                    }
                    realHoldSecond = (holdSecond * x / 100) + 2
                    hold.text = self.timeFormat(realHoldSecond)
                    x+=8
                }
                self.realHoldSecond = 0
                self.x = 33
            }
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) == 0{
            let alert = UIAlertController(title: "通知", message: "這是你的第一次訓練，請先至設定頁面設定您的最高閉氣時間", preferredStyle: .alert)
            let button = UIAlertAction(title: "ok", style: .default) { button in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: {})
        }
        
        self.choiseNumber = UserInfoCenter.shared.loadValue(.userChoise) as? Int ?? 0
        
        
        if let url = Bundle.main.url(forResource: "breath", withExtension: "mp3") {
            breathPlayer = try? AVAudioPlayer(contentsOf: url)
            
        }
        
        if let url = Bundle.main.url(forResource: "breath", withExtension: "mp3") {
            holdPlayer = try? AVAudioPlayer(contentsOf: url)
        }
        
        if let url = Bundle.main.url(forResource: "breath", withExtension: "mp3") {
            donePlayer = try? AVAudioPlayer(contentsOf: url)
            
        }
        
    }
    
    func timeFormat(_ time: Int) -> String {
        return String(format: "%02d:%02d", time / 60 , time % 60)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totaltime = 0
        holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
        switch choiseNumber {
        case 0:
            
            for breath in breathCollevtion{
                if breathSecond <= 60 {
                    breathSecond = 60
                }
                breath.text = self.timeFormat(breathSecond)
                totaltime += breathSecond
                breathSecond -= 15
            }
            
            breathSecond = 150
            
            for hold in holdCollection{
                hold.text = self.timeFormat(holdSecond)
                totaltime += holdSecond
            }
            
            self.totalTimeLabel.text = self.timeFormat(totaltime)
        case 1:
            breathSecond = 120
            holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0)
            
            for breath in breathCollevtion{
                breath.text = self.timeFormat(breathSecond)
                totaltime += breathSecond
            }
            
            for hold in holdCollection{
                if x > 81{
                    x = 81
                }
                realHoldSecond = (holdSecond * x / 100) + 2
                hold.text = self.timeFormat(realHoldSecond)
                x+=8
                totaltime += realHoldSecond
            }
            
            self.totalTimeLabel.text = self.timeFormat(totaltime)
            
            realHoldSecond = 0
            
            x = 33
        default:
            break
        }
    }
    
    
    @objc func co2CountDown(){
        switch count {
        case 1:
            breathSecond -= 1
            breath1.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdPlayer?.play()
            }
        case 2:
            self.holdSecond -= 1
            self.hold1.text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 135
                breathPlayer?.play()
            }
        case 3:
            breathSecond -= 1
            breath2.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 4:
            self.holdSecond -= 1
            self.hold2 .text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
            }
        case 5:
            breathSecond -= 1
            breath3.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 6:
            self.holdSecond -= 1
            self.hold3 .text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 105
                breathPlayer?.play()
            }
        case 7:
            breathSecond -= 1
            breath4.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 8:
            self.holdSecond -= 1
            self.hold4.text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 90
                breathPlayer?.play()
            }
        case 9:
            breathSecond -= 1
            breath5.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 10:
            self.holdSecond -= 1
            self.hold5 .text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 75
                breathPlayer?.play()
            }
        case 11:
            breathSecond -= 1
            breath6.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 12:
            self.holdSecond -= 1
            self.hold6.text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 60
                breathPlayer?.play()
            }
        case 13:
            breathSecond -= 1
            breath7.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 14:
            self.holdSecond -= 1
            self.hold7.text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                count += 1
                self.breathSecond = 60
                breathPlayer?.play()
            }
        case 15:
            breathSecond -= 1
            breath8.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                holdSecond = (UserInfoCenter.shared.loadValue(.canHoldSecond) as? Int ?? 0) / 2
                holdPlayer?.play()
            }
        case 16:
            self.holdSecond -= 1
            self.hold8.text = self.timeFormat(holdSecond)
            if self.holdSecond == 0 {
                totalTimer.invalidate()
                self.startbtnOulet.setTitle("Start", for: .normal)
                donePlayer?.play()
            }
        default:
            break
        }
        
    }
    @objc func O2CountDown(){
        switch count {
        case 1:
            breathSecond -= 1
            breath1.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 33 / 100) + 2
                holdPlayer?.play()
            }
        case 2:
            self.realHoldSecond -= 1
            self.hold1.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
            }
        case 3:
            breathSecond -= 1
            breath2.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 41 / 100) + 2
                holdPlayer?.play()
            }
        case 4:
            self.realHoldSecond -= 1
            self.hold2.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        case 5:
            breathSecond -= 1
            breath3.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 49 / 100) + 2
                holdPlayer?.play()
            }
        case 6:
            self.realHoldSecond -= 1
            self.hold3.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        case 7:
            breathSecond -= 1
            breath4.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 57 / 100) + 2
                holdPlayer?.play()
            }
        case 8:
            self.realHoldSecond -= 1
            self.hold4.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        case 9:
            breathSecond -= 1
            breath5.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 65 / 100) + 2
                holdPlayer?.play()
            }
        case 10:
            self.realHoldSecond -= 1
            self.hold5.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        case 11:
            breathSecond -= 1
            breath6.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 73 / 100) + 2
                holdPlayer?.play()
            }
        case 12:
            self.realHoldSecond -= 1
            self.hold6.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        case 13:
            breathSecond -= 1
            breath7.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 81 / 100) + 2
                holdPlayer?.play()
            }
        case 14:
            self.realHoldSecond -= 1
            self.hold7.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        case 15:
            breathSecond -= 1
            breath8.text = self.timeFormat(breathSecond)
            if breathSecond == 0{
                count += 1
                self.realHoldSecond = (holdSecond * 81 / 100) + 2
                holdPlayer?.play()
            }
        case 16:
            self.realHoldSecond -= 1
            self.hold8.text = self.timeFormat(self.realHoldSecond)
            if self.realHoldSecond == 0 {
                count += 1
                self.breathSecond = 120
                breathPlayer?.play()
                
            }
        default:
            break
        }
        
    }
}


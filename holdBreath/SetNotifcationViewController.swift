import UIKit
import UserNotifications

class SetNotifcationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableNotif: UITableView!
    @IBOutlet weak var textNotifTime: UITextField!
    let pickview = UIDatePicker()
    let fullScreenSize = UIScreen.main.bounds.size
    let currenttime = Date()
    var setTime = Date()
    let formatter = DateFormatter()
    var weekSource = [["week":"禮拜日","check":"false"],["week":"禮拜一","check":"false"],["week":"禮拜二","check":"false"],["week":"禮拜三","check":"false"],["week":"禮拜四","check":"false"],["week":"禮拜五","check":"false"],["week":"禮拜六","check":"false"],]
    var week: [[String:String]] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableNotif.dataSource = self
        self.tableNotif.delegate = self
        self.tableNotif.rowHeight = 50
        self.tableNotif.reloadData()
        
        self.week = UserInfoCenter.shared.loadValue(.notifWeek) as? [[String : String]] ??  self.weekSource
        
        self.formatter.locale = Locale(identifier: "zh_Hant_TW")
        self.formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        self.formatter.dateFormat = "HH:mm"
        
        self.pickview.datePickerMode = .date
        self.pickview.addTarget(self, action: #selector(pickerValueChang), for: .valueChanged)
        self.pickview.frame.size = CGSize(width: 0, height: 250)

        self.textNotifTime.inputView = self.pickview
        self.textNotifTime.addTarget(self, action: #selector(textNotifiTimeTextFieldAction(_:)), for: .valueChanged)

        self.tableNotif.reloadData()

    }
    
    @objc func textNotifiTimeTextFieldAction(_ sender: UITextField!) {
        UserInfoCenter.shared.storeValue(.notifTime, data: sender.text)
        LocalNotificationCenter.shared.regisNotificationDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textNotifTime.text = UserInfoCenter.shared.loadValue(.notifTime) as? String ?? "00:00"
    }
    
    
    @objc func pickerValueChang(sender: UIDatePicker){
        self.textNotifTime.text = formatter.string(from: sender.date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "weekCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = self.weekSource[indexPath.row]["week"]
        if self.week[indexPath.row]["check"] == "true" {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if self.week[indexPath.row]["check"] == "true" {
            self.week[indexPath.row]["check"] = "false"
            cell.accessoryType = .none
        } else {
            self.week[indexPath.row]["check"] = "true"
            cell.accessoryType = .checkmark
        }
        UserInfoCenter.shared.storeValue(.notifWeek, data: self.week)
        LocalNotificationCenter.shared.regisNotificationDate()
    }

    
}

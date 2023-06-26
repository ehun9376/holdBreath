import UIKit
import UserNotifications
//struct notifReminder
//{
//    var day = ""
//    var done = false
//}
class SetNotifcationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableNotif: UITableView!
    @IBOutlet weak var textNotifTime: UITextField!
    let pickview = UIDatePicker()
    let fullScreenSize = UIScreen.main.bounds.size
    let currenttime = Date()
    var setTime = Date()
    let formatter = DateFormatter()
    var homeDataCenter:UserDefaults?
    var weekSource = [["week":"禮拜日","check":"false"],["week":"禮拜一","check":"false"],["week":"禮拜二","check":"false"],["week":"禮拜三","check":"false"],["week":"禮拜四","check":"false"],["week":"禮拜五","check":"false"],["week":"禮拜六","check":"false"],]
    var week:[[String:String]]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableNotif.dataSource = self
        self.tableNotif.delegate = self
        self.tableNotif.rowHeight = 50
        self.tableNotif.reloadData()
        self.homeDataCenter = UserDefaults.init()
        self.week = self.homeDataCenter?.array(forKey: "weekNotif") as? [[String : String]] ?? self.weekSource
        self.formatter.locale = Locale(identifier: "zh_Hant_TW")
        self.formatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        self.formatter.dateFormat = "HH:mm"
        self.pickview.datePickerMode = .time
        self.pickview.addTarget(self, action: #selector(pickerValueChang), for: .valueChanged)
        self.pickview.frame.size = CGSize(width: 0, height: 250)
        self.textNotifTime.inputView = pickview
        tableNotif.reloadData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textNotifTime.text = self.homeDataCenter?.string(forKey: "timeNotif") ?? formatter.string(from: currenttime)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.homeDataCenter?.setValue(self.week, forKey: "weekNotif")
        self.homeDataCenter?.setValue(self.textNotifTime.text, forKey: "timeNotif")
    }
    @objc func pickerValueChang(sender: UIDatePicker){
        self.textNotifTime.text = formatter.string(from: sender.date)
        print(sender.date)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "weekCell")
        cell.textLabel?.text = self.weekSource[indexPath.row]["week"]
        if self.week![indexPath.row]["check"] == "true"{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if self.week![indexPath.row]["check"] == "true"{
            self.week![indexPath.row]["check"] = "false"
            cell.accessoryType = .none
            print(self.week!)
        }
        else{
            self.week![indexPath.row]["check"] = "true"
            cell.accessoryType = .checkmark
            print(self.week!)
        }
    }

    
}

import UIKit
class InfoViewController: UIViewController {
    @IBOutlet weak var textviewInfo: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textviewInfo.text =
            "這是一個專門為自由潛水愛好者開發的APP\n可以使用此APP來協助您練習您的高二氧耐受程度及低血氧忍耐程度\n如果您是第一次使用\n請先至\"找出極限\"介面，利用所提供的計時功能測試自己能夠閉氣的最長時間\n您也可以根據你的喜好設置語音通知\n之後，請至\"設定\"頁面輸入您的閉氣時間\n\"訓練\"頁面中的訓練課表將隨著你設定的時間給您最適合你的課表\n你如果願意也可以在此頁面設定訓練提醒通知"
    }
}

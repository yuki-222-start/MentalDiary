//
//  CalendarViewController.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/27.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import FirebaseAuth
import Lottie


class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var subView: UIView!
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    let auth = Auth.auth()
    var animationView = AnimationView()
    var dateDataString = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        showAnimation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if animationView.isAnimationPlaying == false {
            animationView.play()
        }
    }
    
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        return (year,month,day)
    }
    
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            
            return UIColor.red
            
        }else if weekday == 7 {  //土曜日
            
            return UIColor.blue
            
        }
        return nil
    }
    
    
    //日付がタップされた時に呼ばれるメソッド
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let diaryVC = storyboard?.instantiateViewController(identifier: "diaryVC") as! DiaryViewController
        let dateData = getDay(date)
        dateDataString = ["\(dateData.0)","\(dateData.1)","\(dateData.2)"]
        
        switch dateDataString[2] {
        case "1","2","3","4","5","6","7","8","9":
            dateDataString[2] = "0" + dateDataString[2]
        default:
            break
        }
        
        diaryVC.dateDataString = dateDataString
        
        self.navigationController?.pushViewController(diaryVC, animated: true)
        
    }
    
    //アニメーションをインスタンス化して再生
    func showAnimation(){
        
        animationView = AnimationView(name: "yurukawa")
        animationView.frame = CGRect(x: 0, y: 0, width: subView.frame.size.width, height: subView.frame.size.height)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.5
        
        subView.addSubview(animationView)
        animationView.play()
        
    }
}

//
//  ChartViewController.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Charts

class ChartViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChartLoadOKDlegate,ChartViewDelegate {
    
    @IBOutlet weak var lineCharats: LineChartView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var mentalScoreLabel: UILabel!
    @IBOutlet weak var chartTitleLabel: UILabel!
    
    var chartsTitle = String()
    var dateDataString = ["",""]
    var day = [Double]()
    var lineDataSet: LineChartDataSet!
    let loadDataModel = LoadDataModel()
    var mentalScore = [Double]()
    var month = [String]()
    var pickerView = UIPickerView()
    var year = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateSet()
        loadDataModel.chartLoadOKDelegate = self
        lineCharats.delegate = self
        
        //pickerViewをインスタンス化
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //viewをインスタンス化してpickerViewを貼り付ける
        let view = UIView(frame: pickerView.bounds)
        view.backgroundColor = .white
        view.addSubview(pickerView)
        
        //textFieldをタップした際にキーボードではなくviewが呼ばれるようにする
        textField.delegate = self
        textField.inputView = view
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(ChartViewController.pickerDonePressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    //pickerViewの done ボタンが押された時の処理
    @objc func pickerDonePressed() {
        view.endEditing(true)
    }
    
    //pickerViewに表示する年と月を準備する
    func dateSet(){
        for i in 2020...2021 {
            year.append(String(i))
        }
        for i in 1...12{
            month.append(String(i))
        }
    }
    
    //chartをセットしてviewに反映
    func chartLoadOK(check: Int) {
        
        if check == 1{
    
            var entries = [ChartDataEntry]()
            for data in loadDataModel.chartDataSets {
                
                entries.append(ChartDataEntry(x:data.day!, y: data.mentalScore!))
    
            }
            
            lineDataSet = LineChartDataSet(entries: entries, label: "日付")
            lineDataSet.circleRadius = 5.0
            lineDataSet.circleHoleRadius = 5
            lineDataSet.drawValuesEnabled = false
            
            lineCharats.xAxis.labelPosition = .bottom // x軸ラベルをグラフの下に表示する
            
            lineCharats.leftAxis.axisMaximum = 100 //y左軸最大値
            lineCharats.leftAxis.axisMinimum = 0 //y左軸最小値
            lineCharats.leftAxis.labelCount = entries.count // y軸ラベルの数
            lineCharats.rightAxis.enabled = false
            
            lineCharats.data = LineChartData(dataSet: lineDataSet)
            lineCharats.extraTopOffset = 20
            lineCharats.xAxis.granularity = 1.0
            
            chartTitleLabel.text = "\(chartsTitle)月"
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return year.count
        }else{
            return month.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return year[row]
        }else{
            return month[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            dateDataString[0] = year[row]
        }else{
            dateDataString[1] = month[row]
            chartsTitle = month[row]
        }
        textField.text = dateDataString[0] + "/" + dateDataString[1]
    }
    
    //決定ボタンが押されたときにFirebaseの値を取ってくる
    @IBAction func done(_ sender: Any) {
        
        if textField.text!.isEmpty != true{
            
            loadDataModel.chartloadData(dateDataString: dateDataString)
            
        }
    }
    
    //チャートのタップされた場所の値を取得しラベルに表示
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let dataSet = lineCharats.data?.dataSets[highlight.dataSetIndex] {
            
            let sliceIndex = dataSet.entryIndex(entry: entry)
            
            let mentalScore = Int(loadDataModel.chartDataSets[sliceIndex].mentalScore!)
            let day = Int(loadDataModel.chartDataSets[sliceIndex].day!)
            mentalScoreLabel.text = "メンタルスコア \(String(mentalScore))"
            dayLabel.text = "\(String(day))日"
        }
    }
}


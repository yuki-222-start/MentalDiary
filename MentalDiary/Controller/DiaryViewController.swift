//
//  DiaryViewController.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/27.
//

import UIKit

class DiaryViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,LoadOKDelegate {
    
    var dateDataString = [String]()
    let sendDataModel = SendDataModel()
    let loadDataModel = LoadDataModel()
    
    @IBOutlet weak var mentalScoreTextField: UITextField!
    @IBOutlet weak var diaryTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mentalScoreTextField.delegate = self
        diaryTextView.delegate = self
        loadDataModel.loadOKDelegate = self
        
        mentalScoreTextField.keyboardType = UIKeyboardType.numberPad
        
        //textViewの枠線の設定
        diaryTextView.layer.borderColor = UIColor.black.cgColor
        diaryTextView.layer.borderWidth = 1.0
        diaryTextView.layer.cornerRadius = 10.0
        diaryTextView.layer.masksToBounds = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        loadDataModel.loadData(dateDataString: dateDataString)
        
    }
    
    //保存完了アラート
    func okAlertSetUp(){
            let alert:UIAlertController = UIAlertController(title: "タイトル", message: "保存が完了しました", preferredStyle: UIAlertController.Style.alert)
            let oKButton:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
                print("OK")
            }
            alert.addAction(oKButton)
            present(alert, animated: true, completion: nil)
        
    }
    
    //保存失敗アラート
    func notOKAlertSetUp() {
        let alert:UIAlertController = UIAlertController(title: "タイトル", message: "正しく入力されていません", preferredStyle: UIAlertController.Style.alert)
        let oKButton:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (UIAlertAction) in
            print("OK")
        }
        alert.addAction(oKButton)
        present(alert, animated: true, completion: nil)
    }
    
    //以前に入力されていれば画面に値を表示
    func loadOK(check: Int, dataSets:[DataSets]) {
        
        mentalScoreTextField.text = dataSets[0].mentalScore
        diaryTextView.text = dataSets[0].diary
        
    }
    
    //保存ボタンが押されたらFirebaseに保存
    @IBAction func saveButton(_ sender: Any) {
        
        if mentalScoreTextField.text?.isEmpty == false,diaryTextView.text.isEmpty == false {
            
            sendDataModel.sendData(mentalScore: mentalScoreTextField.text!, diary: diaryTextView.text, dateDataString: dateDataString)
            
            okAlertSetUp()
        }else{
            notOKAlertSetUp()
        }
    }
}

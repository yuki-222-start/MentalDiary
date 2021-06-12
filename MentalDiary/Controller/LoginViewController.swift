//
//  LoginViewController.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/27.
//

import UIKit
import Lottie
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var subview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAnimation()
    }
    
    //アニメーションをセットしてスタートする
    func showAnimation(){
        
        let animationView = AnimationView(name: "yurukawa")
        animationView.frame = CGRect(x: 0, y: 0, width: subview.frame.size.width , height: subview.frame.size.height)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.5
        
        subview.addSubview(animationView)
        

        animationView.play()
        
    }
    
    //ログイン
    func login(){
        //Authに値を送ってresultかerrorが返ってくる
        Auth.auth().signInAnonymously { (result, error) in
            
            if error != nil{
                print("error")
                return
            }
            
            let calendarVC = self.storyboard?.instantiateViewController(identifier: "calendarVC") as! CalendarViewController
            self.textField.text = ""
            self.navigationController?.pushViewController(calendarVC, animated: true)
            
        }
    }
    
    
    //画面をタッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textField.resignFirstResponder()
        
    }
    
    //Enterでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
    }
    //決定ボタンで名前をFirebaseに保存して画面遷移
    @IBAction func done(_ sender: Any) {
        if textField.text?.isEmpty != true{
            
           login()
            
        }
    }
}

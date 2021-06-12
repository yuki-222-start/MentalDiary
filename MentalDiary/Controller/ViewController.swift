//
//  ViewController.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/27.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var dairyImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //5秒かけてdairyImageViewのアルファ値を0~1にしてふわっと現れるようにする
        UIView.animate(withDuration: 5.0) {
            self.dairyImageView.alpha += 1.0
        }
    }
    
    
    //画面をタッチしたら画面遷移するようにする
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //ログイン済みならcalendarVCへ遷移
        if Auth.auth().currentUser?.uid != nil{
            let calendarVC = storyboard?.instantiateViewController(identifier: "calendarVC") as! CalendarViewController
            navigationController?.pushViewController(calendarVC, animated: true)
        }else{
            //未ログインならloginVCへ遷移
            let loginVC = storyboard?.instantiateViewController(identifier: "loginVC") as! LoginViewController
            navigationController?.pushViewController(loginVC, animated: true)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
}


//
//  loadData.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/28.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

//DiaryVCようのロード完了プロトコル
protocol LoadOKDelegate {
    func loadOK(check:Int,  dataSets:[DataSets])
}

//ChartVCようのロード完了プロトコル
protocol ChartLoadOKDlegate {
    func chartLoadOK(check:Int)
}


class LoadDataModel{
    
    var chartDataSets = [ChartDataSets]()
    var chartLoadOKDelegate:ChartLoadOKDlegate?
    var dataSets = [DataSets]()
    let db = Firestore.firestore()
    var loadOKDelegate:LoadOKDelegate?
    let uid = Auth.auth().currentUser?.uid
    
    //DiaryVCようのFirebaseからデータを取得するメソッド
    func loadData(dateDataString:[String]){
        
        db.collection(uid! + dateDataString[0]).whereField("month", isEqualTo: dateDataString[1]).whereField("day", isEqualTo: dateDataString[2]).addSnapshotListener {(snapShot, error) in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    self.dataSets = []
                    if let mentalScore = data["mentalScore"] as? String,let diary = data["diary"] as? String,let month = data["month"] as? String,let day = data["day"] as?String{
                        
                        let newDataSets = DataSets(mentalScore:mentalScore,diary:diary,month:month,day:day)
                        self.dataSets.append(newDataSets)
                        self.loadOKDelegate?.loadOK(check: 1, dataSets: self.dataSets)
                        
                    }
                }
            }
        }
    }
    
    //chartVCようのFirebaseからデータを取得するメソッド
    func chartloadData(dateDataString:[String]){
        
        db.collection(uid! + dateDataString[0]).whereField("month", isEqualTo: dateDataString[1]).order(by: "day").addSnapshotListener {(snapShot, error) in
            
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let mentalScore = data["mentalScore"] as? String, let day = data["day"] as? String{
                        
                        print(mentalScore)
                        let newDataSets = ChartDataSets(mentalScore:Double(mentalScore),day:Double(day))
                        self.chartDataSets.append(newDataSets)
                        self.chartLoadOKDelegate?.chartLoadOK(check: 1)
                    
                    }
                }
            }
        }
    }
}

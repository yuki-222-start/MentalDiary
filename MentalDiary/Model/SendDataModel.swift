//
//  File.swift
//  MentalDiary
//
//  Created by 佐藤友輝 on 2021/04/27.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SendDataModel{
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    
    
    func sendData(mentalScore:String,diary:String,dateDataString:[String]){
        
        db.collection(uid! + dateDataString[0]).document(dateDataString[1] + dateDataString[2]).setData(["mentalScore":mentalScore,"diary":diary,"month":dateDataString[1],"day":dateDataString[2]])
        
    }
}

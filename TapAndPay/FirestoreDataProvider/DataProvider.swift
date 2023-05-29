//
//  DataProvider.swift
//  TapAndPay
//
//  Created by Neosoft on 24/05/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
class DataProvider{
    static let shared = DataProvider()
    var isTestWithoutNfc = false
    private let db = Firestore.firestore()
    private init(){
    }
    func GetFirestoreProduct(nfcId:String, completion: @escaping (Bool, ProductModel?,String) -> ()) {
            db.collection("productlist").whereField("pId", isEqualTo: nfcId).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(false,nil, err.localizedDescription)
                } else {
                    if let documents = querySnapshot?.documents,let document = documents.first, let product:ProductModel? = document.data().castToObject(){
                        completion(true,product, "Sucess")
                    }
                    else {
                        completion(false,nil, "Something went wrong")
                    }
                }
            }
    }
    
    func GetFirestoreUPI(completion: @escaping (Bool, UPIModel?,String) -> ()) {
            db.collection("upiData").getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    completion(false,nil, err.localizedDescription)
                } else {
                    if let documents = querySnapshot?.documents,let document = documents.first, let upiModel:UPIModel? = document.data().castToObject(){
                        completion(true,upiModel, "Sucess")
                    }
                    else {
                        completion(false,nil, "Something went wrong")
                    }
                }
            }
    }
}

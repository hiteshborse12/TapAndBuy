//
//  ProductModel.swift
//  FirebaseDatabse
//
//  Created by Neosoft on 07/04/23.
//

import Foundation
class ProductModel:Decodable {
    let pId: String?
    let pNmae: String?
    let pPrice: String?
    let pImage:String?
    let pDesp:String?
    var docId: String?
    var pQty: Int = 1
    enum CodingKeys:String,CodingKey {
            case pId, pNmae, pPrice, pImage,pDesp, docId
    }
    func getTotalPrice()->Int{
        return pQty * (Int(self.pPrice ?? "0") ?? 0)
    }
}

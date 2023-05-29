//
//  CheckoutViewModel.swift
//  TapAndPay
//
//  Created by Neosoft on 24/05/23.
//

import Foundation
enum UPIPayment{
    case paytm
    case googlePay
    case phonePay
    public var getDeeplinkUPIID: String {
       switch self {
       case .paytm:
           return "paytm://pay?pa="
       case .googlePay:
           return "Tez://upi/pay?pa="
       case .phonePay:
           return "Phonepe://pay?pa="

       }
   }
}
class CheckoutViewModel {
    var productList : [ProductModel] = [ProductModel]()
    private var uPIid = "sushanttoraskar61@okaxis"
    private func getPaymentUPIID(isGooglePay:Bool = false)->String{
        if isGooglePay{
            return "\(self.uPIid)&cu=INR&mc=TapNPayShop&appName=TapNPayShop&tn=TapNPayShop&am=\(self.getTotalPrice()).0&pn=TapNPayShop&tr=TapNPayShop"
        }
        return "\(self.uPIid)&pn=TapNPayShop&cu=inr&tn=TapNPayShop&am=\(self.getTotalPrice())"
    }
}
extension CheckoutViewModel {
    func getTotalPrice() -> Int{
        var total = 0
        for product in productList{
            let productTotal = product.getTotalPrice()
            total = total + productTotal
        }
        return total
    }
    func paytmPayUPI() -> String{
        return UPIPayment.paytm.getDeeplinkUPIID + self.getPaymentUPIID()
    }
   func googlePayUPI() -> String {
       return UPIPayment.googlePay.getDeeplinkUPIID + self.getPaymentUPIID(isGooglePay: true)
    }
    func phonePayUPI()  -> String{
        return UPIPayment.phonePay.getDeeplinkUPIID + self.getPaymentUPIID()
    }
}
extension CheckoutViewModel{
    func fetchUPIData(completion: @escaping (Bool, UPIModel?,String) -> ()) {
        DataProvider.shared.GetFirestoreUPI { isSucess, upidModel, message in
            self.uPIid =  upidModel?.upiId ?? "sushanttoraskar61@okaxis"
            completion(isSucess,upidModel, message)
        }
    }
}

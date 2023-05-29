import Foundation
class HomeViewModel {
    private var uPIid = "sushanttoraskar61@okaxis"
    private func getPaymentUPIID()->String{
        return "\(self.uPIid)&pn=TapNPayShop&cu=inr&tn=TapNPayShop"
    }
}
extension HomeViewModel{
    func paytmPayUPI() -> String{
        return UPIPayment.paytm.getDeeplinkUPIID + self.getPaymentUPIID()
    }
    func fetchUPIData(completion: @escaping (Bool, UPIModel?,String) -> ()) {
        DataProvider.shared.GetFirestoreUPI { isSucess, upidModel, message in
            self.uPIid =  upidModel?.upiId ?? "sushanttoraskar61@okaxis"
             completion(isSucess,upidModel,message)
        }
    }
}

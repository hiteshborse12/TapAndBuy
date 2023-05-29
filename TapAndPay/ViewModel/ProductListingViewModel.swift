import Foundation
class ProductListingViewModel {
    private var productList : [ProductModel] = [ProductModel]()
}

extension ProductListingViewModel{
    func setProductList(list: [ProductModel]){
        self.productList = list
    }
    func getProductList() -> [ProductModel]{
        self.productList
    }
    func getTotalCount() -> Int{
        self.productList.count
    }
    func getProductAtIndex(index:Int) -> ProductModel{
        self.productList[index]
    }
    func addProduct(product:ProductModel){
        self.productList.append(product)
    }
    func deleteProduct(index: Int) {
        if index <= self.productList.count - 1{
            self.productList.remove(at: index)
        }
    }
    func getTotalPrice() -> Int{
        var total = 0
        for product in productList{
            let productTotal = product.getTotalPrice()
            total = total + productTotal
        }
        return total
    }
    func getCheckOutButtonTitle() -> String{
        if self.getTotalPrice() > 0{
            return "Checkout \(self.getTotalPrice()) ₹"
        }
        else {
            return "Checkout"
        }
    }
}
extension ProductListingViewModel{
    func fetchData(nfcId:String, completion: @escaping (Bool, ProductModel?,String) -> ()) {
        DataProvider.shared.GetFirestoreProduct(nfcId: nfcId) { isSucess, productModel, message in
            completion(isSucess,productModel, message)
        }
    }
}

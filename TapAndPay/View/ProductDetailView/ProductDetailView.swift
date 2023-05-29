//
//  ProductDetailView.swift
//  TapAndPay
//
//  Created by sushant's Macbook on 02/05/23.
//

import UIKit
protocol ProductDetailViewDelegate{
    func addProductToCart(product: ProductModel)
}
class ProductDetailView: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productTotal: UILabel!
    @IBOutlet weak var quantityOfProduct: UILabel!
    var delegate:ProductDetailViewDelegate?
    var product: ProductModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    func setupVC(){
        self.productName.text = "\( product?.pNmae ?? "")"
        self.productDescription.text = "\(product?.pDesp ?? "")"
        self.productType.text = "\(product?.pPrice ?? "") ₹"
        self.productImage.setImageWith(url: product?.pImage ?? "")
        self.updateTotalpriceNQty()
    }
    @IBAction func handlePlusButtonAction(){
        self.product?.pQty = ( self.product?.pQty ?? 1) + 1
        self.updateTotalpriceNQty()
    }
    @IBAction func handleMinusButtonAction(){
        self.product?.pQty = ( self.product?.pQty ?? 0) - 1
        if (self.product?.pQty ?? 0 <= 0){
            self.product?.pQty = 1
        }
        self.updateTotalpriceNQty()
    }
    
    @IBAction func handleCancel(){
        self.dismiss(animated: false)
    }
    
    @IBAction func handleAddToCart(){
        if let product = self.product{
            self.delegate?.addProductToCart(product: product)
            self.dismiss(animated: false)
        }
    }
    func updateTotalpriceNQty(){
        self.productTotal.text = "\(self.product?.getTotalPrice() ?? 0) ₹"
        self.quantityOfProduct.text = "\(self.product?.pQty ?? 0)"
    }
}

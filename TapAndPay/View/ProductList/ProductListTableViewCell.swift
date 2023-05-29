//
//  ProductListTableViewCell.swift
//  FirebaseDatabse
//
//  Created by Neosoft on 06/04/23.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    @IBOutlet weak var pNameLabel: UILabel!
    @IBOutlet weak var pPriceLabel: UILabel!
    @IBOutlet weak var pTotalLabel: UILabel!
    @IBOutlet weak var pDesLabel: UILabel!
    @IBOutlet weak var pImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(product:ProductModel){
        self.pNameLabel.text = "\( product.pNmae ?? "")"
        self.pPriceLabel.text = "Price: \(product.pPrice ?? "") ₹"
        self.pTotalLabel.text = "\(product.pPrice ?? "") ₹ ✕ \(product.pQty) = \(product.getTotalPrice()) ₹"
        self.pDesLabel.text = "\(product.pDesp ?? "")"
        self.pImageView.setImageWith(url: product.pImage ?? "")
    }
    
}

//
//  CheckoutViewController.swift
//  TapAndPay
//
//  Created by Neosoft on 24/05/23.
//

import UIKit

class CheckoutViewController: UIViewController {
    let viewModel = CheckoutViewModel()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissLoading()
        self.getUPIiD()
    }
    func getUPIiD(){
        self.showLoading()
        viewModel.fetchUPIData { isSucess, upidModel, message in
            self.dismissLoading()
            if isSucess{
                
            }
            else {
                self.showAlert(withTitle: "", withMessage: message)
            }
        }
    }
    @IBAction func paytmPayButtonAction(_ sender: Any) {
        self.openUPIApp(urlStr:  viewModel.paytmPayUPI())
    }
    @IBAction func googlePayButtonAction(_ sender: Any) {
        self.openUPIApp(urlStr: viewModel.googlePayUPI())
    }
    @IBAction func phonePayButtonAction(_ sender: Any) {
        self.openUPIApp(urlStr:  viewModel.phonePayUPI())
    }
    func openUPIApp(urlStr:String){
          guard let url = URL(string: urlStr) else { return }
        UIApplication.shared.open(url, completionHandler: { success in
           if success{
              DispatchQueue.main.async {
                  self.isPaymentDone()
              }
           }
        })
    }
    private func isPaymentDone() {
        let alert = UIAlertController(title: "Thanks you!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OrderSummeryViewController") as! OrderSummeryViewController
            vc.viewModel.setProductList(list: self.viewModel.productList)
            self.navigationController?.pushViewController(vc, animated: true)
        }))
                        
        alert.addAction(UIAlertAction(title: "Retry Payment", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    private func dismissLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
}

//
//  OrderSummeryViewController.swift
//  TapAndPay
//
//  Created by Neosoft on 29/05/23.
//

import UIKit

class OrderSummeryViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var viewModel = ProductListingViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setuUI()
    }
    private func setuUI(){
        self.tableview.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListTableViewCell")
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backAction(sender:)))
        navigationItem.leftBarButtonItems = [doneButton]
        self.dismissLoading()
        }

    @objc func backAction(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
        }
    
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    private func dismissLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

extension OrderSummeryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTotalCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
        let product = viewModel.getProductAtIndex(index: indexPath.row)
        cell.setupCell(product: product)
        return cell
    }
}

import UIKit

class ProductListingViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkoutButton: DesignableButton!
    var viewModel = ProductListingViewModel()
    let nfcManager = NFCManager()
    var startWithNFC = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setuUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkDeepLink()
        if startWithNFC{
            self.readNFCtag()
            startWithNFC = false
        }
    }
    func checkDeepLink(){
        switch(Constants.isAppOpenThroughDeepLinik()){
        case .upiDeepLink(_):
            Constants.appDelegate.resetDeepLinkingFlag()
            break
        case .productDeepLink(let pid):
             getProduct(pid: pid)
             Constants.appDelegate.resetDeepLinkingFlag()
        case .empty:
            break
        }
    }
    private func setuUI(){
        self.tableview.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListTableViewCell")
            self.dismissLoading()
    }
    
    @IBAction func addProduct(_ sender: Any) {
        if DataProvider.shared.isTestWithoutNfc{
            self.getProduct()
         }
         else{
             readNFCtag()
         }
    }
    @IBAction func checkout(_ sender: Any) {
        if viewModel.getTotalCount() > 0{
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            vc.viewModel.productList = self.viewModel.getProductList()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            self.showAlert(withTitle: "Tap And Buy", withMessage: "Please add prodcut in cart")
        }
    }
    func getProduct(pid:String = "pid1"){
        self.showLoading()
        viewModel.fetchData(nfcId: pid) { isSucess, productModel, message in
            self.dismissLoading()
            if isSucess{
                let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopupViewController") as! ProductDetailView
                vc.product = productModel
                vc.delegate = self
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: false)
            }
            else {
                self.showAlert(withTitle: "", withMessage: message)
            }
        }
    }
    
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    private func dismissLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

extension ProductListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.checkoutButton.setTitle(viewModel.getCheckOutButtonTitle(), for: .normal)
        return viewModel.getTotalCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell", for: indexPath) as! ProductListTableViewCell
        let product = viewModel.getProductAtIndex(index: indexPath.row)
        cell.setupCell(product: product)
        return cell
    }
}
extension ProductListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteProduct(index: indexPath.row)
            self.tableview.reloadData()
        }
    }
}
extension ProductListingViewController:ProductDetailViewDelegate{
    func addProductToCart(product: ProductModel) {
        self.viewModel.addProduct(product: product)
        self.tableview.reloadData()
    }
}
extension ProductListingViewController{
    func readNFCtag(){
      nfcManager.read { manager in
            // Session did become active
            manager.setMessage("Hold iPhone near the cart shelf to add prodcut")
        } didDetect: { manager, result in
            switch result {
            case .failure:
                self.showAlert(withTitle: "Tap And Buy", withMessage: "Failed to read tag")
            case .success(let message):
                guard let record = message?.records.first,let payloadText = String(data: record.payload, encoding: .utf8),payloadText.lowercased().contains(Constants.deeplinkProduct.lowercased()), let pId = payloadText.split(separator: "/").last else {
                    self.showAlert(withTitle: "Tap And Buy", withMessage: "Invalid Tag")
                    return
                     }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.getProduct(pid: "\(pId)")
                })
               
               
           }
        }
    }
}

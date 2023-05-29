import UIKit
import CoreNFC
 
class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let nfcManager = NFCManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissLoading()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkDeepLink()
    }
    @IBAction func tapNShopAction(_ sender: Any) {
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListingViewController") as! ProductListingViewController
        vc.startWithNFC = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapNPayAction(_ sender: Any) {
       if DataProvider.shared.isTestWithoutNfc{
            getUPIiD()
        }
        else{
           readNFCtag()
        }
    }
    @IBAction func exploreStoreAction(_ sender: Any) {
        guard let url = URL(string: "https://www.google.com/") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func nfcSwitch(_ sender: UISwitch) {
        DataProvider.shared.isTestWithoutNfc = sender.isOn
    }
    func checkDeepLink(){
        switch(Constants.isAppOpenThroughDeepLinik()){
        case .upiDeepLink(_):
             readNFCtag()
            Constants.appDelegate.resetDeepLinkingFlag()
        case .productDeepLink(_):
             gotoProductListingViewController()
        case .empty:
            break
        }
    }
    func gotoProductListingViewController() {
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductListingViewController") as! ProductListingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getUPIiD(){
        self.showLoading()
        viewModel.fetchUPIData { isSucess, upidModel, message in
            self.dismissLoading()
            if isSucess{
                self.openUPIApp(urlStr:  self.viewModel.paytmPayUPI())
            }
            else {
                self.showAlert(withTitle: "", withMessage: message)
            }
        }
    }
    func openUPIApp(urlStr:String){
          guard let url = URL(string: urlStr) else { return }
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    private func dismissLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}
extension HomeViewController{
    func readNFCtag(){
      nfcManager.read { manager in
            // Session did become active
            manager.setMessage("Hold iPhone near the tag to pay")
        } didDetect: { manager, result in
            switch result {
            case .failure:
                self.showAlert(withTitle: "Tap And Buy", withMessage: "Failed to read tag")
            case .success(let message):
                guard let record = message?.records.first,let payloadText = String(data: record.payload, encoding: .utf8),payloadText.lowercased().contains(Constants.deeplinkUPI.lowercased()) else {
                    self.showAlert(withTitle: "Tap And Buy", withMessage: "Invalid Tag")
                             return
                     }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.getUPIiD()
                })
                
           }
        }
    }
}

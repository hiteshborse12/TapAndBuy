import UIKit
import SDWebImage

extension UIImageView {
    
    func setImageWith(url: String, placeHolder: UIImage = #imageLiteral(resourceName: "noImage")) {
        self.sd_setImage(with: URL(string: url), placeholderImage: placeHolder, options: [], context: [:])
    }

}

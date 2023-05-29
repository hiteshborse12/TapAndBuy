//
//  Constants.swift
//  TapAndPay
//
//  Created by Neosoft on 25/05/23.
//

import Foundation
import UIKit
enum DeepLink{
    case upiDeepLink(Bool)
    case productDeepLink(String)
    case empty
}
class Constants{
    static let deeplinkUPI = "TP_Upi"
    static let deeplinkProduct = "TP_Product"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static func isAppOpenThroughDeepLinik() -> DeepLink{
        if Constants.appDelegate.upiDeepLink{
            return DeepLink.upiDeepLink(true)
        }
        else if let pid = Constants.appDelegate.productDeepLink{
            return DeepLink.productDeepLink(pid)
        }
        return DeepLink.empty
    }
    
}

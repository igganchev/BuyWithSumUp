//
//  AppDelegate+Extension.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.05.19.
//

import Foundation
import UIKit

extension UIApplicationDelegate {
    static var shared: Self {
        return UIApplication.shared.delegate! as! Self
    }
}

//
//  ProductItem.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.03.19.
//

import UIKit

class ProductItem {
    let image: UIImage?
    let title: String
    let price: NSNumber
    let description: String
    
    init(image: UIImage?, title: String, price: NSDecimalNumber, description: String) {
        self.image = image
        self.title = title
        self.price = price
        self.description = description
    }
    
    var priceString: String {
        let dollarFormatter: NumberFormatter = NumberFormatter()
        dollarFormatter.minimumFractionDigits = 2;
        dollarFormatter.maximumFractionDigits = 2;
        return dollarFormatter.string(from: price)!
    }
}

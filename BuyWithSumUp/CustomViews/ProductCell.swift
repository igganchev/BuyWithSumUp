//
//  ProductCell.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.03.19.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var swagImage: UIImageView!
    
    func loadWith(data: Product) {
        guard let title = data.title, let imageName = data.imageName else {
            return
        }
        
        titleLabel.text = title
        priceLabel.text = "$\(data.price)"
        swagImage.image = UIImage(named: imageName)
    }
}

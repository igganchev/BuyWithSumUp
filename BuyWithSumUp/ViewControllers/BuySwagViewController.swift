//
//  DetailViewController.swift
//  ApplePaySwag
//
//  Created by Ivan Ganchev on 7.03.19.
//

import UIKit

class BuyProductViewController: UIViewController {
    
    private let viewModel = BuyProductViewModel()
    
    @IBOutlet weak var swagPriceLabel: UILabel!
    @IBOutlet weak var swagTitleLabel: UILabel!
    @IBOutlet weak var swagImage: UIImageView!
    @IBOutlet weak var applePayButton: UIButton!
    
    var swag: ProductItem! {
        didSet {
            self.configureView()
        }
    }

    func configureView() {

        if (!self.isViewLoaded) {
            return
        }
        
        self.title = swag.title
        self.swagPriceLabel.text = "$" + swag.priceString
        self.swagImage.image = swag.image
        self.swagTitleLabel.text = swag.description
        
        applePayButton.backgroundColor = .clear
        applePayButton.layer.cornerRadius = 5
        applePayButton.layer.borderWidth = 1
        applePayButton.layer.borderColor = UIColor.blue.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // Purchase button tapped
    @IBAction func purchase(_ sender: UIButton) {
        viewModel.buySwag(withTitle: swag.title, withPrice: swag.priceString) { [weak self] (receipt) in
            // Presenting the receipt
            DispatchQueue.main.async {
                let receiptVC = ReceiptViewController(forReceipt: receipt)
                let navController = UINavigationController(rootViewController: receiptVC)
                
                self?.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
    }
}



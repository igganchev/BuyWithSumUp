//
//  Receipt.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 8.03.19.
//

import Foundation

class Receipt {
    // MARK: - Properties
    // The two dicts received from the NetworkManger
    private var transactionDataDict: [String: Any]?
    private var merchantDataDict: [String: Any]?
    
    // These are sub-dicts of them
    private var merchantProfileDict: [String: Any]?
    private var productDict: [String: Any]?
    private var merchantAddressDict: [String: Any]?
    
    // MARK: - Initialization
    // Initiatilizing a receipt with the two main dicts from the JSON and creating the sub-dicts
    init(transactionDataDict: [String: Any], merchantDataDict: [String: Any]) {
        self.transactionDataDict = transactionDataDict
        self.merchantDataDict = merchantDataDict
        
        if let merchantProfileDict = merchantDataDict["merchant_profile"] as? [String: Any] {
            self.merchantProfileDict = merchantProfileDict
        } else {
            self.merchantProfileDict = nil
        }
        
        if let productsArray = transactionDataDict["products"] as? [[String: Any]], let product = productsArray.first {
            self.productDict = product
        } else {
            self.productDict = nil
        }
        
        if let merchantAddressDict = merchantProfileDict?["address"] as? [String: Any] {
            self.merchantAddressDict = merchantAddressDict
        } else {
            self.merchantAddressDict = nil
        }
    }
    
    // MARK: - Functions to return receipt compenents
    // These are used to populate the ReceiptViewController
    func merchantCode() -> String? {
        if let merchantCode = merchantProfileDict?["merchant_code"] as? String {
            return merchantCode
        } else {
            return nil
        }
    }
    
    func transactionCode() -> String? {
        if let transactionCode = transactionDataDict?["transaction_code"] as? String {
            return transactionCode
        } else {
            return nil
        }
    }
    
    func cardTypeAndNumber() -> String? {
        guard let cardDict = transactionDataDict?["card"] as? [String: Any] else {
            return nil
        }
        
        if let cardType = cardDict["type"] as? String, let cardLastDigits = cardDict["last_4_digits"] as? String {
            return "\(cardType) ****\(cardLastDigits)"
        } else {
            return nil
        }
    }
    
    func entryMode() -> String? {
        if let entryMode = transactionDataDict?["entry_mode"] as? String {
            return entryMode
        } else {
            return nil
        }
    }
    
    func status() -> String? {
        if let status = transactionDataDict?["status"] as? String {
            return status
        } else {
            return nil
        }
    }
    
    func timestamp() -> String? {
        if let timestamp = transactionDataDict?["timestamp"] as? String {
            guard var timestampToFormat = timestamp.components(separatedBy: ".").first  else {
                return nil
            }
            timestampToFormat.append("Z")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = dateFormatter.date(from: timestampToFormat) else {
                return nil
            }
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd.MM.yyyy, HH:mm"
            
            return dateFormatterPrint.string(from: date)
        } else {
            return nil
        }
    }
    
    func productName() -> String? {
        if let productName = productDict?["name"] as? String {
            return productName
        } else {
            return nil
        }
    }
    
    func productQuantity() -> String? {
        if let productQuantity = productDict?["quantity"] as? Int {
            return productQuantity.description
        } else {
            return nil
        }
    }
    
    func productPrice() -> String? {
        if let productPrice = productDict?["total_price"] as? String {
            return productPrice
        } else {
            return nil
        }
    }
    
    func totalPrice() -> String? {
        if let totalPrice = transactionDataDict?["amount"] as? String {
            return totalPrice
        } else {
            return nil
        }
    }
    
    func currency() -> String? {
        if let currency = transactionDataDict?["currency"] as? String {
            return currency
        } else {
            return nil
        }
    }
    
    func merchantName() -> String? {
        if let merchantName = merchantProfileDict?["business_name"] as? String {
            return merchantName
        } else {
            return nil
        }
    }
    
    func merchantEmail() -> String? {
        if let merchantEmail = merchantProfileDict?["email"] as? String {
            return merchantEmail
        } else {
            return nil
        }
    }

    func merchantAddressLineOne() -> String? {
        if let merchantAddressLineOne = merchantAddressDict?["address_line1"] as? String {
            return merchantAddressLineOne
        } else {
            return nil
        }
    }
    
    func merchantPostCode() -> String? {
        if let merchantPostCode = merchantAddressDict?["post_code"] as? String {
            return merchantPostCode
        } else {
            return nil
        }
    }
    
    func merchantCity() -> String? {
        if let merchantCity = merchantAddressDict?["city"] as? String {
            return merchantCity
        } else {
            return nil
        }
    }
    
    func merchantCountry() -> String? {
        if let merchantCountry = merchantAddressDict?["country_native_name"] as? String {
            return merchantCountry
        } else {
            return nil
        }
    }
    
    func location() -> (String, String)? {
        if let locationDict = transactionDataDict?["location"] as? [String: Any] {
            guard let lat = locationDict["lat"] as? String, let lon = locationDict["lon"] as? String else {
                return nil
            }
            
            return (lat, lon)
        } else {
            return nil
        }
    }
}

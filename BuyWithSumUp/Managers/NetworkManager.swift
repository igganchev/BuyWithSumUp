//
//  NetworkManager.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 8.03.19.
//

import Foundation

class NetworkManager {
    // MARK: - Functions
    // Requesting a receipt from the SumUp API, takes a MID and a TID, has a completion block which stores the receipt object
    static func requestSumUpReceipt(forMID merchantCode: String, withTID transactionCode: String, completion: @escaping (Receipt?) -> Void) {
        let urlString = "https://receipts-ng.sumup.com/v0.1/receipts/\(transactionCode)?mid=\(merchantCode)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = NSURLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                if let receiptData = data, let jsonDict = try JSONSerialization.jsonObject(with: receiptData, options: []) as? [String: Any] {
                    if let transactionDataDict = jsonDict["transaction_data"] as? [String: Any], let merchantDataDict = jsonDict["merchant_data"] as? [String: Any] {
                        // Creating a receipt object
                        let receipt = Receipt(transactionDataDict: transactionDataDict, merchantDataDict: merchantDataDict)
                        // Storing the receipt object
                        completion(receipt)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

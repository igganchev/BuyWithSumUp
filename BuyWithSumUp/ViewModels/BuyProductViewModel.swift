//
//  BuyProductViewModel.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 9.03.19.
//

import Foundation

class BuyProductViewModel {
    
    // MARK: - Properties
    private let sumUpSDKManager = SumUpSDKManager()
    
    // MARK: - Functions
    // Takes a title and a price and has a completion block, which contains a receipt if the transaction was initiated
    func buySwag(withTitle title: String, withPrice price: String, completion: @escaping (Receipt) -> Void) {
        sumUpSDKManager.purchaseItem(withTitle: title, withPrice: price) { (MID, TID) in
            guard let MID = MID, let TID = TID else {
                return
            }
            
            
            NetworkManager.requestSumUpReceipt(forMID: MID, withTID: TID) { (receipt) in
                guard let receipt = receipt else {
                    return
                }
                
                completion(receipt)
            }
        }
    }
}

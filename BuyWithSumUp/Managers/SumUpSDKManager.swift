//
//  SumUpSDKManager.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.03.19.
//

import Foundation
import SumUpSDK

class SumUpSDKManager {
    // MARK: - Properties
    // A static variable to check whether the SDK is already setup
    private static var sumUpSDKIsSetUp: Bool = false
    
    // MARK: - Initialization
    // Initialize the SumUp SDK with the corresponding API key only once
    init() {
        if !SumUpSDKManager.sumUpSDKIsSetUp {
            SumUpSDK.setup(withAPIKey: "9f2671c4-9613-448b-868c-ca8d4fe7e64b")
            SumUpSDKManager.sumUpSDKIsSetUp = true
        } else {
            return
        }
    }
    
    // MARK: - SumUp SDK funcionality
    // Initiating a SumUp purchase request, has a completion block which stores a MID and a TID for an initiated transaction
    func purchaseItem(withTitle title: String, withPrice priceString: String, resultHandler: @escaping (String?, String?) -> Void) {
        // Validate the price string
        let price = NSDecimalNumber(string: priceString)
        guard price != NSDecimalNumber.zero else {
            return
        }
        
        // Present a login screen if the user hasn't logged in yet, otherwise allow them to log out
        if !SumUpSDK.isLoggedIn {
            login() { [weak self] in
                // Present the checkout screen
                self?.requestCheckout(withTitle: title, withPrice: price) { (MID, TID) in
                    resultHandler(MID, TID)
                }
            }
        } else {
            showLogoutAlert() { [weak self] in
                // Present the checkout screen
                self?.requestCheckout(withTitle: title, withPrice: price) { (MID, TID) in
                    resultHandler(MID, TID)
                }
            }
        }
    }
    
    // Presenting the login screen, has a completion block
    private func login(loginCompleteion: @escaping () -> Void) {
        SumUpSDK.presentLogin(from: (UIApplication.shared.keyWindow?.rootViewController)!, animated: true) { (success: Bool, error: Error?) in
            loginCompleteion()
        }
    }
    
    // Logging out and immediately presenting the login screen with its completion handler
    private func logout(loginCompletion: @escaping () -> Void) {
        SumUpSDK.logout { [weak self] (success: Bool, error: Error?) in
            self?.login() {
                loginCompletion()
            }
        }
    }
    
    // Present a checkout screen
    private func requestCheckout(withTitle title: String, withPrice price: NSDecimalNumber, resultHandler: @escaping (String?, String?) -> Void) {
        // Validating currency
        guard let merchantCurrencyCode = SumUpSDK.currentMerchant?.currencyCode else {
            return
        }
        
        // Creating a request based on the title, price and currency
        let request = CheckoutRequest(total: price, title: title, currencyCode: merchantCurrencyCode)
        
        // Initiating the checkout with the request
        SumUpSDK.checkout(with: request, from: (UIApplication.shared.keyWindow?.rootViewController)!) { (result: CheckoutResult?, error: Error?) in
            // In case of an error, printing it and then returning
            if let safeError = error as NSError? {
                print("error during checkout: \(safeError)")
                
                if (safeError.domain == SumUpSDKErrorDomain) && (safeError.code == SumUpSDKError.accountNotLoggedIn.rawValue) {
                    print("not logged int")
                } else {
                    print("general error")
                }
                
                return
            }
            
            guard let safeResult = result else {
                return
            }
            
            print("result_transaction==\(safeResult.transactionCode ?? "nil")")
            
            // Return the MID and the TID through the completion block (resultHandler) if a result exists
            if safeResult.success {
                resultHandler(SumUpSDK.currentMerchant?.merchantCode, safeResult.transactionCode)
                let message = "Thank you - \(safeResult.transactionCode ?? "nil"))"
                print(message)
            } else {
                if safeResult.transactionCode != nil {
                    resultHandler(SumUpSDK.currentMerchant?.merchantCode, safeResult.transactionCode)
                }
                print("No charge (cancelled)")
            }
        }
    }
    
    // MARK: - Helper functions
    // Showing an alert allowing the merchant to log out of the current account or to continue with it
    private func showLogoutAlert(loginCompletion: @escaping () -> Void) {
        let alert = UIAlertController(title: "Current account", message: "You are currently logged in as \(SumUpSDK.currentMerchant?.merchantCode ?? ""). Do you wish to continue?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
            loginCompletion()
        }))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] (UIAlertAction) in
            self?.logout() {
                loginCompletion()
            }
        }))

        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

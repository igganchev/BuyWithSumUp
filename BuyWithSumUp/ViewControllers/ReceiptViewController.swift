//
//  ReceiptViewController.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.03.19.
//

import UIKit
import MapKit

class ReceiptViewController: UIViewController {
    
    // MARK: - Properties
    // A receipt object to populate the view
    private let receipt: Receipt?
    
    @IBOutlet weak var scrollView: UIScrollView!
    // Receipt label outlets
    @IBOutlet weak var merchantCode: UILabel!
    @IBOutlet weak var transactionCode: UILabel!
    @IBOutlet weak var cardTypeAndNumber: UILabel!
    @IBOutlet weak var entryMode: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCurrency: UILabel!
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var totalCurrency: UILabel!
    
    @IBOutlet weak var merchantName: UILabel!
    @IBOutlet weak var merchantEmail: UILabel!
    @IBOutlet weak var merchantAddressLineOne: UILabel!
    @IBOutlet weak var merchantPostCode: UILabel!
    @IBOutlet weak var merchantCity: UILabel!
    @IBOutlet weak var merchantCountry: UILabel!
    
    @IBOutlet weak var seeOnMapButton: UIButton!
    
    // MARK: - Initialization
    init(forReceipt receipt: Receipt) {
        self.receipt = receipt
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+100)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissSelf))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(createAndSharePDF))
        setLabels()
    }
    
    // MARK: - Helper functions
    // Dismisses the view upon tapping the "Back" bar button
    @objc private func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }

    // Sets the labels from the receipt object
    private func setLabels() {
        merchantCode.text = receipt?.merchantCode()
        transactionCode.text = receipt?.transactionCode()
        cardTypeAndNumber.text = receipt?.cardTypeAndNumber()
        entryMode.text = receipt?.entryMode()
        
        status.text = receipt?.status()
        timestamp.text = receipt?.timestamp()
        
        productName.text = receipt?.productName()
        productQuantity.text = receipt?.productQuantity()
        productPrice.text = receipt?.productPrice()
        productCurrency.text = receipt?.currency()
        
        totalPrice.text = receipt?.totalPrice()
        totalCurrency.text = receipt?.currency()
        
        merchantName.text = receipt?.merchantName()
        merchantEmail.text = receipt?.merchantEmail()
        merchantAddressLineOne.text = receipt?.merchantAddressLineOne()
        merchantPostCode.text = receipt?.merchantPostCode()
        merchantCity.text = receipt?.merchantCity()
        merchantCountry.text = receipt?.merchantCountry()
    }
    
    // Opens Maps based on the location of the transaction
    func openMapForTransactionLocation() {
        guard let latString = receipt?.location()?.0, let lonString = receipt?.location()?.1 else {
            return
        }
        
        guard let latDouble = Double(latString), let lonDouble = Double(lonString) else {
            return
        }
        
        guard let latitude = CLLocationDegrees(exactly: latDouble), let longitude = CLLocationDegrees(exactly: lonDouble) else {
            return
        }
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Transaction location"
        mapItem.openInMaps(launchOptions: options)
    }
    
    // Pressing the map button
    @IBAction func seeOnMapButtonPressed(_ sender: UIButton) {
        openMapForTransactionLocation()
    }
    
    // Creating a very simple .pdf from the view and sharing it
    @objc func createAndSharePDF() {
        // Hide the "See on map" button, as the generated pdf in non-interactable
        seeOnMapButton.isHidden = true
        
        // Create a simple .pdf
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.view.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        self.view.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        // Show to button after the .pdf is created
        seeOnMapButton.isHidden = false
        
        // Share the .pdf
        let pdfToShare = [ pdfData ]
        let activityViewController = UIActivityViewController(activityItems: pdfToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

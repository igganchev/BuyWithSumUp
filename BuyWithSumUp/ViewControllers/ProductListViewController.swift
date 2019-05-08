//
//  ProductListViewController.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.03.19.
//

import UIKit
import CoreData

class ProductListViewController: UITableViewController {
    
    // MARK: - Properties
    lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let fetchRequest = Product.productFetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchRequestController.delegate = self
        
        return fetchRequestController
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFetch()

        if let sections = fetchedResultsController.sections {
            if sections[0].numberOfObjects == 0 {
                populateDatabase()
            }
        } else {
            populateDatabase()
        }
    }
    
    // MARK: - Helper functions
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print(fetchError.localizedDescription)
        }
    }
    
    // Returns a ProductItem object from the database for a given index path
    private func getProduct(at indexPath: IndexPath) -> ProductItem? {
        let currentProductData = fetchedResultsController.object(at: indexPath)
        guard let title = currentProductData.title, let imageName = currentProductData.imageName, let description = currentProductData.productDescription else {
            return nil
        }
        
        let product = ProductItem(image: UIImage(named: imageName), title: title, price: NSDecimalNumber(value: currentProductData.price), description: description)
        return product
    }
    
    // Populates the database with a few sample products
    private func populateDatabase() {
        addProductToDatabase(   imageName: "1",
                title: "Smartwatch",
                price: 260.00,
                description: "This smartwatch is both extremely stylish and incredibly useful.")
        
        addProductToDatabase(   imageName: "2",
                title: "Headphones",
                price: 54.00,
                description: "The newest headphones offer great sound at a very low price.")
        
        addProductToDatabase(   imageName: "3",
                title: "Sneakers",
                price: 70.99,
                description: "A pair of very comfortable sneakers!")

        addProductToDatabase(   imageName: "4",
                title: "Socks",
                price: 2.99,
                description: "Those sock look and feel really warm. Your feet will be thankful for having them!")
        
        addProductToDatabase(   imageName: "5",
                title: "Pepsi",
                price: 1.99,
                description: "A can of refreshing cold Pepsi.")
    }
    
    // MARK: Saving to database
    private func addProductToDatabase(imageName: String?, title: String?, price: Double?, description: String?) {
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                Product.createProductWith(imageName: imageName, title: title, price: price, productDescription: description, managedObjectContext: delegate.managedObjectContext)
            }
        }
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = getProduct(at: indexPath)
                (segue.destination as! BuyProductViewController).swag = object
            }
        }
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if let productCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell {
            productCell.loadWith(data: fetchedResultsController.object(at: indexPath))
            cell = productCell
        }
        
        return cell ?? UITableViewCell()
    }
}

extension ProductListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let productCell = tableView.cellForRow(at: indexPath) as? ProductCell {
                productCell.loadWith(data: fetchedResultsController.object(at: indexPath))
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            fatalError()
        }
        
    }
}



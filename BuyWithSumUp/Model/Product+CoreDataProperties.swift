//
//  Product+CoreDataProperties.swift
//  BuyWithSumUp
//
//  Created by Ivan Ganchev on 7.05.19.
//

import Foundation
import CoreData


extension Product {
    
    @nonobjc public class func productFetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }
    
    @NSManaged public var imageName: String?
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var productDescription: String?
    
    class func createProductWith(imageName: String?, title: String?, price: Double?, productDescription: String?, managedObjectContext: NSManagedObjectContext?) {
        guard let imageName = imageName, let title = title, let price = price, let productDescription = productDescription, let managedObjectContext = managedObjectContext else {
            return
        }

        guard let entityValue = NSEntityDescription.entity(forEntityName: "Product", in: managedObjectContext) else {
            return
        }
        
        if let record = NSManagedObject(entity: entityValue, insertInto: managedObjectContext) as? Product {
            record.imageName = imageName
            record.title = title
            record.price = price
            record.productDescription = productDescription
            
            do {
                try record.managedObjectContext?.save()
            } catch {
                let saveError = error as NSError
                print("\(saveError), \(saveError.userInfo)")
            }
        }
    }
}

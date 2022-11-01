//
//  CartInteractor.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 30/10/2022.
//

import UIKit
import CoreData

class CartInteractor : CartInteractorProtocol {
    var presenter: CartPresenterProtocol?
    var list : [CartItemEntity]?
    
    func updateItem(itemId: String, count : Int) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "ItemEntity")
        let predicate = NSPredicate(format: "itemID == %@", itemId as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let req = try managedContext.fetch(fetchRequest)
            for object in req {
                object.setValue(count, forKey: "count")
            }
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteItem(itemId: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "ItemEntity")
        let predicate = NSPredicate(format: "itemID == %@", itemId as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let req = try managedContext.fetch(fetchRequest)
            for object in req {
                managedContext.delete(object)
                print("ITEM DELETED")
            }
            
            do {
                try managedContext.save()
                list = list?.filter { $0.itemID != itemId }
                fetchItems()
            } catch {
                print(error)
            }
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchItems(){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "ItemEntity")
        do {
            list?.removeAll()
            let fetchedResult = try managedContext.fetch(fetchRequest)
            for item in fetchedResult {
                let itemID = item.value(forKey: "itemID")! as! String
                let arabicName = item.value(forKey: "arabicName")! as! String
                let englishName = item.value(forKey: "englishName")! as! String
                let price = item.value(forKey: "price")! as! Double
                let count = item.value(forKey: "count")! as! Int
                let picURL = item.value(forKey: "picURL")! as! String
                
                let obj = CartItemEntity.init(itemID: itemID,arabicName: arabicName, englishName: englishName, price: price, count: count, picURL: picURL)
                print("OBJ :-", obj)
                if (list?.append(obj)) == nil {
                    list = [obj]
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        presenter?.medsFetched(medsList: list ?? [])
        print("LIST : - ",list)
    }
}

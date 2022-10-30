//
//  SearchInteractor.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation
import Alamofire
import CoreData

@available(iOS 13.0, *)
class SearchInteractor : SearchInteractorProtocol {
    
    var presenter: SearchPresenterProtocol?
    var cartItems: [NSManagedObject] = []

    func fetchItems(queryText: String) {
        let parameters = [
            "indexFrom": "1",
            "indexTo": "200",
            "searchKey": queryText
        ]
        let url = URL(string: "http://40.127.194.127:5656/Salamtak/GetMedicationItems")!
        AF.request(url, method: .post, parameters: parameters).responseDecodable(of: MedicationItems.self) { response in
            switch response.result {
            case .success(let value):
                if let data = response.data , let utf8Text = String(data: data, encoding: .utf8) {
                    if let networkResponse = response.response {
                        print(networkResponse)
                        self.presenter?.medsFetched(medsList: value)
                    }
                }
            case .failure(let error):
                self.presenter?.medsFetched(with: error.localizedDescription)
            }
        }
    }
    
    func saveToCoreData(item: CartItemEntity) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
          }
          
          // 1
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          // 2
          let entity =
            NSEntityDescription.entity(forEntityName: "ItemEntity",
                                       in: managedContext)!
          
          let cartItem = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
          
          // 3
        cartItem.setValue(item.itemID, forKey: "itemID")
        cartItem.setValue(item.arabicName, forKey: "arabicName")
        cartItem.setValue(item.englishName, forKey: "englishName")
        cartItem.setValue(item.price, forKey: "price")
        cartItem.setValue(item.count, forKey: "count")
        cartItem.setValue(item.picURL, forKey: "picURL")

          // 4
          do {
            try managedContext.save()
              cartItems.append(cartItem)
              print("SAVE SUCCESS")
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
  
}

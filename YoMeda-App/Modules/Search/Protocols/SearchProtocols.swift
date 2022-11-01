//
//  Protocols.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation
import UIKit

//MARK: - View Protocol
protocol SearchViewProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    
    func update(with items: MedicationItems)
    func reloadTableView()
    func updateWithError(with error: String)
}

//MARK: - Interactor Protocol

protocol SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?  { get set }
    
    func fetchItems(queryText: String)
    func saveToCoreData(item: CartItemEntity)
    func updateCoreDataItem(itemId: String, count : Int)
}

//MARK: - Presenter Protocol

protocol SearchPresenterProtocol {
    var router : SearchRouterProtocol? { get set }
    var interactor : SearchInteractorProtocol? { get set }
    var view : SearchViewProtocol? { get set }
    var medsList : [CartItemEntity]? { get set}

    //interactor
    func medsFetched(medsList: [CartItemEntity])
    func medsFetched(with error: String)
    
    // view
    func startLoading(queryText: String)
    func getMedsCount() -> Int
    func getMedItem(at index: IndexPath) -> CartItemEntity
    func removeMedItems()
    func confirmMeds()
}

//MARK: - Router Protocol

protocol SearchRouterProtocol {
    func createModule() -> UIViewController

    func routeToCart()
}



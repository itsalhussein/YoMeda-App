//
//  Protocols.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation
import UIKit

//MARK: - View Protocol
protocol CartViewProtocol {
    var presenter: CartPresenterProtocol? { get set }
    
    func update(with items: [CartItemEntity])
    func updateWithError(with error: String)
}

//MARK: - Interactor Protocol

protocol CartInteractorProtocol {
    var presenter: CartPresenterProtocol?  { get set }
    
    func fetchItems()
    func updateItem(itemId: String, count : Int)
    func deleteItem(itemId: String)

    
}

//MARK: - Presenter Protocol

protocol CartPresenterProtocol {
    var router : CartRouterProtocol? { get set }
    var interactor : CartInteractorProtocol? { get set }
    var view : CartViewProtocol? { get set }

    
    //interactor
    func medsFetched(medsList: [CartItemEntity])
    func medsFetched(with error: String)
    
    
    // view
    func getMedsCount() -> Int
    func getMedItem(at index: IndexPath) -> CartItemEntity
    func deleteMedItem(with id: String)
    func updateMedItem(with id: String, count: Int)
    func back()
}

//MARK: - Router Protocol

protocol CartRouterProtocol {

    static func createModule() -> UIViewController
    func routeToSearch()
}



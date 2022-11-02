//
//  SearchPresenter.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation
import UIKit

class SearchPresenter : SearchPresenterProtocol {
    var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?

    var medsList : [CartItemEntity] = []
    
    init(view: SearchViewProtocol, interactor: SearchInteractorProtocol?, router: SearchRouterProtocol) {
           self.view = view
           self.interactor = interactor
           self.router = router
    }
    
    func fetchItems(queryText: String, startIndex: String, endIndex: String){
        interactor?.fetchItems(queryText: queryText, startIndex: startIndex, endIndex: endIndex)
    }

    func medsFetched(medsList: [CartItemEntity]) {
        self.medsList.append(contentsOf: medsList)
        self.view?.reloadTableView()
    }

    func medsFetched(with error: String) {
        self.view?.updateWithError(with: error)
    }

    func getMedsCount() -> Int {
        print("NEWCOUNT: - \(self.medsList.count ?? 0)")
        return self.medsList.count ?? 0
    }

    func getMedItem(at index: IndexPath) -> CartItemEntity {
        return self.medsList[index.row]
    }
    func removeMedItems(){
        medsList.removeAll()
    }
    func confirmMeds(){
        self.router?.routeToCart()
    }
}

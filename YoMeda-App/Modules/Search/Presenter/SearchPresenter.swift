//
//  SearchPresenter.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation

class SearchPresenter : SearchPresenterProtocol {
    
    var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?

    var medsList : MedicationItems?
    
    func startLoading(queryText: String){
        interactor?.fetchItems(queryText: queryText)
    }

    func medsFetched(medsList: MedicationItems) {
        self.medsList = medsList
        self.view?.update(with: medsList)
    }

    func medsFetched(with error: String) {
        self.view?.updateWithError(with: error)
    }

    func getMedsCount() -> Int {
        print("COUNT: - \(self.medsList?.complaints?.count)")
        return self.medsList?.complaints?.count ?? 0
    }

    func getMedItem(at index: IndexPath) -> Complaints {
        return self.medsList!.complaints![index.row]
    }
    func removeMedItems(){
        medsList?.complaints?.removeAll()
    }
    func confirmMeds(){
        self.router?.routeToCart()
    }
    
}

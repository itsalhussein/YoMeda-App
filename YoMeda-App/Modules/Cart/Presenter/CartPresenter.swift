//
//  CartPresenter.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 30/10/2022.
//

import Foundation

class CartPresenter: CartPresenterProtocol {

    var router: CartRouterProtocol?
    var interactor: CartInteractorProtocol?
    var view: CartViewProtocol?
    
    var cartList : [CartItemEntity]?
    
    init(view: CartViewProtocol, interactor: CartInteractorProtocol?, router: CartRouterProtocol) {
           self.view = view
           self.interactor = interactor
           self.router = router
    }

    func medsFetched(medsList: [CartItemEntity]) {
        cartList = medsList
        self.view?.update(with: cartList ?? [])
    }
    
    func medsFetched(with error: String) {
        self.view?.updateWithError(with: error)
    }
    func getMedsCount() -> Int {
        print("COUNT: - \(self.cartList?.count)")
        return self.cartList?.count ?? 0
    }

    func getMedItem(at index: IndexPath) -> CartItemEntity {
        return self.cartList![index.row]
    }
    
    func deleteMedItem(with id: String){
        interactor?.deleteItem(itemId: id)
    }
    func updateMedItem(with id: String, count: Int){
        interactor?.updateItem(itemId: id, count: count)
    }
    func back(){
        router?.routeToSearch()
    }
}

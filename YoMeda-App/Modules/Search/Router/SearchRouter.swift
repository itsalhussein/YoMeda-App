//
//  SearchRouter.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation
import UIKit

typealias EntryPoint = SearchViewProtocol & UIViewController

@available(iOS 13.0, *)
class SearchRouter : SearchRouterProtocol {
    
    var entry: EntryPoint?
    var navigationController: UINavigationController?
    
    static func start() -> SearchRouterProtocol {
        let router = SearchRouter()
        var view : SearchViewProtocol = SearchVC()
        var presenter : SearchPresenterProtocol = SearchPresenter()
        var interactor : SearchInteractorProtocol = SearchInteractor()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        router.entry = view as? EntryPoint
        
        return router
    }
    func routeToCart() {
        let cart = CartRouter.createModule()
        if let nav = self.entry {
            cart.modalPresentationStyle = .overCurrentContext
            cart.modalTransitionStyle = .crossDissolve
            nav.present(cart, animated: true, completion: nil)
        }else{
            print("navigation controller not found")
        }
    }
}

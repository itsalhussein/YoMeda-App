//
//  SearchRouter.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation
import UIKit


class SearchRouter : SearchRouterProtocol {
    
    var navigationController: UINavigationController?
    
    func createModule() -> UIViewController {

        let view = SearchVC(nibName: "SearchVC", bundle: nil)
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let navigation = UINavigationController(rootViewController: view)
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.navigationController = navigation
        
        return navigation
    }
    func routeToCart() {
        let cart = CartRouter.createModule()
        self.navigationController?.pushViewController(cart, animated: true)
      
    }
}

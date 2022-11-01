//
//  CartRouter.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 30/10/2022.
//

import UIKit

class CartRouter : CartRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = CartVC(nibName: "CartVC", bundle: nil)
        let interactor = CartInteractor()
        let router = CartRouter()
        let presenter = CartPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func routeToSearch() {
        if UserDefaultsConstants.cartCount == 0 {
            UserDefaultsConstants.totalAmount = 0
            UserDefaultsConstants.cartCount = 0
            NotificationCenter.default
                .post(name: Notification.Name("showTotalData"), object: nil)
        }
        self.viewController?.navigationController?.popToRootViewController(animated: true)
    }
    
}

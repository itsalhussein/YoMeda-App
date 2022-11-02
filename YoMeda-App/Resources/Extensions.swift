//
//  Extensions.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 29/10/2022.
//

import Foundation
import UIKit

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

extension UIViewController{
    func toroot() {
            AppDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            let router = SearchRouter()
            let initialVC = router.createModule()
            AppDelegate.window?.rootViewController = initialVC
            AppDelegate.window?.makeKeyAndVisible()
    }
    
   
}




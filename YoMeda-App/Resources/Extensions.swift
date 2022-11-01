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

extension UINavigationController {
    func setNavBarImage(_ image:UIImage?) {
        
        guard let image = image  else {return}
        
        self.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        
        //clear statusBar color
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.clear
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




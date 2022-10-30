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
    
    //    func setStatusBar(backgroundColor: UIColor) {
    //        let statusBarFrame: CGRect
    //        if #available(iOS 13.0, *) {
    //            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
    //        } else {
    //            statusBarFrame = UIApplication.shared.statusBarFrame
    //        }
    //        let statusBarView = UIView(frame: statusBarFrame)
    //        statusBarView.backgroundColor = backgroundColor
    //        view.addSubview(statusBarView)
    //    }
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



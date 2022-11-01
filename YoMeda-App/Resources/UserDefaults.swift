//
//  UserDefaults.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 31/10/2022.
//

import Foundation
struct UserDefaultsConstants {
    
    static var totalAmount: Double {
        set {
            UserDefaults().set(newValue, forKey: "TOTALAMOUNT")
        }
        get {
            return UserDefaults().double(forKey: "TOTALAMOUNT")
        }
    }
    
    static var cartCount: Int {
        set {
            UserDefaults().set(newValue, forKey: "CARTCOUNT")
        }
        get {
            return UserDefaults().integer(forKey: "CARTCOUNT")
        }
    }
}

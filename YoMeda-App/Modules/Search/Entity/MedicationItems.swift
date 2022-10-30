//
//  MedicationItems.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation

struct MedicationItems : Codable {
    var complaints : [Complaints]?
    var selectedMedicines : String?
    var success : Bool?
    var code : Int?
    var englishMessage : String?
    var arabicMessage : String?
    var currentPage : Int?
    var isArabic : String?
    var pageCount : Int?
    var visitStatus : String?

    enum CodingKeys: String, CodingKey {

        case complaints = "complaints"
        case selectedMedicines = "SelectedMedicines"
        case success = "Success"
        case code = "Code"
        case englishMessage = "EnglishMessage"
        case arabicMessage = "ArabicMessage"
        case currentPage = "CurrentPage"
        case isArabic = "IsArabic"
        case pageCount = "PageCount"
        case visitStatus = "VisitStatus"
    }

    init(){
        
    }

}

//
//  Complaints.swift
//  YoMeda-App
//
//  Created by Hussein Anwar on 28/10/2022.
//

import Foundation

struct Complaints : Codable {
    let id : String?
    let code : String?
    let arabicName : String?
    let englishName : String?
    let pages_count : Int?
    let rnum : Int?
    let quantity : Int?
    let indexCount : Int?
    let specialtyId : String?
    let specialtyId2 : String?
    let specialtyId3 : String?
    let isAlreadyChecked : String?
    let isEnabled : String?
    let isLimited : Int?
    let groupCode : String?
    let description : String?
    let picUrl : String?
    let price : Double?
    let oldPrice : String?
    let isDrug : Bool?
    let covidGroupName : String?
    let covidGroupNameEN : String?
    let covidGroupCode : String?
    let covidGroupSort : String?

    enum CodingKeys: String, CodingKey {

        case id = "Id"
        case code = "code"
        case arabicName = "ArabicName"
        case englishName = "EnglishName"
        case pages_count = "pages_count"
        case rnum = "rnum"
        case quantity = "Quantity"
        case indexCount = "indexCount"
        case specialtyId = "SpecialtyId"
        case specialtyId2 = "SpecialtyId2"
        case specialtyId3 = "SpecialtyId3"
        case isAlreadyChecked = "IsAlreadyChecked"
        case isEnabled = "IsEnabled"
        case isLimited = "IsLimited"
        case groupCode = "GroupCode"
        case description = "Description"
        case picUrl = "PicUrl"
        case price = "Price"
        case oldPrice = "OldPrice"
        case isDrug = "IsDrug"
        case covidGroupName = "CovidGroupName"
        case covidGroupNameEN = "CovidGroupNameEN"
        case covidGroupCode = "CovidGroupCode"
        case covidGroupSort = "CovidGroupSort"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        arabicName = try values.decodeIfPresent(String.self, forKey: .arabicName)
        englishName = try values.decodeIfPresent(String.self, forKey: .englishName)
        pages_count = try values.decodeIfPresent(Int.self, forKey: .pages_count)
        rnum = try values.decodeIfPresent(Int.self, forKey: .rnum)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        indexCount = try values.decodeIfPresent(Int.self, forKey: .indexCount)
        specialtyId = try values.decodeIfPresent(String.self, forKey: .specialtyId)
        specialtyId2 = try values.decodeIfPresent(String.self, forKey: .specialtyId2)
        specialtyId3 = try values.decodeIfPresent(String.self, forKey: .specialtyId3)
        isAlreadyChecked = try values.decodeIfPresent(String.self, forKey: .isAlreadyChecked)
        isEnabled = try values.decodeIfPresent(String.self, forKey: .isEnabled)
        isLimited = try values.decodeIfPresent(Int.self, forKey: .isLimited)
        groupCode = try values.decodeIfPresent(String.self, forKey: .groupCode)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        picUrl = try values.decodeIfPresent(String.self, forKey: .picUrl)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        oldPrice = try values.decodeIfPresent(String.self, forKey: .oldPrice)
        isDrug = try values.decodeIfPresent(Bool.self, forKey: .isDrug)
        covidGroupName = try values.decodeIfPresent(String.self, forKey: .covidGroupName)
        covidGroupNameEN = try values.decodeIfPresent(String.self, forKey: .covidGroupNameEN)
        covidGroupCode = try values.decodeIfPresent(String.self, forKey: .covidGroupCode)
        covidGroupSort = try values.decodeIfPresent(String.self, forKey: .covidGroupSort)
    }

}

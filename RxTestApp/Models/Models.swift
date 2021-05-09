//
//  Models.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 8.05.2021.
//

import Foundation

struct Object: Decodable {
    let image: String?
    let name: String?
    let year: Int?
    let medium: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "primaryImageSmall", name = "objectName", year = "objectEndDate", medium
    }
    
}

struct QueryObjects: Decodable {
    let total: Int?
    let objectIDs: [Int]?
}


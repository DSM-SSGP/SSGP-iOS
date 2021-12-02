//
//  ProductList.swift
//  SSGP
//
//  Created by 장서영 on 2021/11/22.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation

struct ProductResponse: Codable {
    var product_id: String
    var name: String
    var brands: [String]
    var selling: [Selling]?
    var price: Int
    var like_count: Int
    var image_path: String?
}

struct Selling: Codable {
    var brand: String
    var content: String
    var selling_price: Int
    var price: Int
}

struct Search: Codable {
    var application_responses: [ProductResponse]
}

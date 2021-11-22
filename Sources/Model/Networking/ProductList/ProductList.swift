//
//  ProductList.swift
//  SSGP
//
//  Created by 장서영 on 2021/11/22.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation

struct ProductResponse: Codable {
    var productId = Int()
    var name = String()
    var price = String()
    var store_kind = [String]()
    var image_path = String()

    init(productId: Int, name: String, price: String, store_kind: [String], image_path: String) {
        self.productId = productId
        self.name = name
        self.price = price
        self.store_kind = store_kind
        self.image_path = image_path
    }
}

struct ProductList: Codable {
    var products = [ProductResponse]()
}

//
//  CSStoreModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/11/23.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation

struct CSStoreModel: Codable {
    let address_name: String
    let category_name: String
    let phone: String
    let place_name: String
    let x: String
    let y: String
}

extension CSStoreModel {
    func categoryNameToBrand() -> Brand {
        let brandName = category_name.replacingOccurrences(
            of: "가정,생활 > 편의점 > ",
            with: ""
        )
        switch brandName {
        case "CU":
            return .cu
        case "GS25":
            return .gs25
        case "이마트24":
            return .emart24
        case "미니스톱":
            return .ministop
        default:
            return .sevenEleven
        }
    }
}

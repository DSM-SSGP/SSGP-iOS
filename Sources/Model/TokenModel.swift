//
//  TokenModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/11/18.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation

struct TokenModel: Codable {
    let access_token: String
    let refresh_token: String
}

struct RefreshedTokenModel: Codable {
    let access_token: String
}

//
//  SSGPAPI.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Moya
import KeychainSwift

enum SSGPAPI {
    // auth
    case login(_ id: String, _ password: String)
    case signUp(_ id: String, _ password: String)
    case tokenRefresh

    // Mypage
    case likeList
    case updatePassword(_ password: String)
    case onOffNotice
    
    // Map
    case findNearbyStore(_ x: String, _ y: String)
    case showNotificationList

    // Product
    case popularityList
    case recommendationList
    case lowestList
    case productDetail(_ productId: String)
    case likeProduct(_ userId: String, _ productId: String)
    case searchProduct
}

extension SSGPAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.215.192:8000")!
    }

    var path: String {
        switch self {
        case .login:
            return "/auth"
        case .tokenRefresh:
            return "/refresh"
        case .signUp, .onOffNotice:
            return "/user"
        case .likeList:
            return "/likelist"
        case .updatePassword:
            return "/password"
        case .findNearbyStore(let x, let y):
            return "/map/\(x)/\(y)"
        case .showNotificationList:
            return "/notification/list"
        case .popularityList:
            return "/product/popular"
        case .recommendationList:
            return "/product/recommend"
        case .lowestList:
            return "/product/lowPrice"
        case .productDetail(let productId):
            return "/product/detail/\(productId)"
        case .likeProduct(_, let productId):
            return "/product/detail/\(productId)"
        case .searchProduct:
            return "/product/lowPrice"
        }
    }

    var method: Moya.Method {
        switch self {
        case .findNearbyStore, .showNotificationList,
                .likeList, .popularityList, .recommendationList, .lowestList,
                .productDetail, .searchProduct:
            return .get
        case .login, .signUp:
            return .post
        case .updatePassword, .onOffNotice:
            return .patch
        case .tokenRefresh, .likeProduct:
            return .put
        }
    }

    var task: Task {
        switch self {
        case .login(let id, let password),
                .signUp(let id, let password):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "password": password
                ],
                encoding: JSONEncoding.prettyPrinted
            )

        case .updatePassword(let password):
            return .requestParameters(
                parameters: [
                    "password": password
                ],
                encoding: JSONEncoding.prettyPrinted
            )

        case .likeProduct(let userId, let productId):
            return .requestParameters(
                parameters: [
                    "userId": userId,
                    "productId": productId
                ],
                encoding: URLEncoding.default
            )

        default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        switch self {
        case .login, .signUp:
            return ["Content-Type": "application/json"]
        case .tokenRefresh:
            return [
                "Refresh_Token": refreshToken,
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Authorization": "Bearer " + accessTocken,
                "Content-Type": "application/json"
            ]
        }
    }
    
    var validationType: ValidationType{
        return .successAndRedirectCodes
    }

    private var accessTocken: String {
        let keychain = KeychainSwift()
        return keychain.get("ACCESS-TOKEN") ?? ""
    }

    private var refreshToken: String {
        let keychain = KeychainSwift()
        return keychain.get("REFRESH-TOKEN") ?? ""
    }

    private var id: String {
        let keychain = KeychainSwift()
        return keychain.get("ID") ?? ""
    }

    private var password: String {
        let keychain = KeychainSwift()
        return keychain.get("PASSWORD") ?? ""
    }

}

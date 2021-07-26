//
//  HTTPClient.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class HTTPClient {
    public static let shared = HTTPClient()
    private let provider = MoyaProvider<SSGPAPI>()

    public func networking<T: Codable>(api: SSGPAPI, model networkModel: T.Type) -> Single<T> {
        return provider.rx.request(api).map(T.self)
    }
}

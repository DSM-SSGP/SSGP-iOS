//
//  SSGPAPI.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Moya

enum SSGPAPI {
}

extension SSGPAPI: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }

    var path: String {
        return ""
    }

    var method: Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return nil
    }

}

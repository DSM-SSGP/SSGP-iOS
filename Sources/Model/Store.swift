//
//  Store.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/28.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

/// 편의점 종류
enum Store {
    case gs25
    case cu
    case ministop
    case sevenEleven
    case emart24
}

extension Store {
    func fitImage() -> UIImage {
        switch self {
        case .gs25:
            return R.image.gs25()!
        case .cu:
            return R.image.cU()!
        case .ministop:
            return R.image.ministoP()!
        case .sevenEleven:
            return R.image.seveneleveN()!
        case .emart24:
            return R.image.emart24()!
        }
    }
}

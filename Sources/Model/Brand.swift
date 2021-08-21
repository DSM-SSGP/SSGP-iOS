//
//  Brand.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/28.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit

/// 편의점 종류
enum Brand {
    case gs25
    case cu
    case ministop
    case sevenEleven
    case emart24
}

extension Brand {
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

    func fitAnnotaionImage() -> UIImage {
        switch self {
        case .gs25:
            return R.image.gs25ANT()!
        case .cu:
            return R.image.cuANT()!
        case .ministop:
            return R.image.ministopANT()!
        case .sevenEleven:
            return R.image.sevenelevenANT()!
        case .emart24:
            return R.image.emart24ANT()!
        }
    }

    func fitColor() -> UIColor {
        switch self {
        case .gs25:
            return #colorLiteral(red: 0.1567118764, green: 0.6941494942, blue: 0.811663568, alpha: 1)
        case .cu:
            return #colorLiteral(red: 0.4588235294, green: 0.07065688819, blue: 0.5254271626, alpha: 1)
        case .ministop:
            return #colorLiteral(red: 0.1176881716, green: 0.05100970715, blue: 0.5058218837, alpha: 1)
        case .sevenEleven:
            return #colorLiteral(red: 0, green: 0.4431563616, blue: 0.3019121885, alpha: 1)
        case .emart24:
            return #colorLiteral(red: 0.9999296069, green: 0.7176957726, blue: 0.1057628766, alpha: 1)
        }
    }
}

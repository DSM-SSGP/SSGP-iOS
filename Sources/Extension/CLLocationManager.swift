//
//  CLLocationManager.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import CoreLocation
import RxSwift

extension CLLocationManager {
    func userLocation() -> Single<CLLocationCoordinate2D> {
        return Single.create { single in
            DispatchQueue.global().async {
                while true {
                    if let userLocation = self.location?.coordinate {
                        DispatchQueue.main.async {
                            single(.success(userLocation))
                        }
                        break
                    }
                }
            }
            return Disposables.create()
        }
    }
}

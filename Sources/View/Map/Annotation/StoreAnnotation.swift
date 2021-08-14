//
//  StoreAnnotation.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/07.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import MapKit
import RxSwift

class StoreAnnotation: NSObject, MKAnnotation {

    public let disposeBag = DisposeBag()

    let identifier: Int
    var title: String?
    let locationName: String?
    let discipline: String?
    let calloutImage: String
    let saleInfo: String
    let brand: Brand
    let coordinate: CLLocationCoordinate2D

    public let calloutView = UIView().then {
        $0.snp.makeConstraints {
            $0.height.equalTo(110)
            $0.width.equalTo(80)
        }
    }

    init(
        identifier: Int,
        title: String?,
        locationName: String?,
        discipline: String?,
        calloutImage: String,
        saleInfo: String,
        brand: Brand,
        coordinate: CLLocationCoordinate2D
    ) {
        self.identifier = identifier
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.calloutImage = calloutImage
        self.saleInfo = saleInfo
        self.brand = brand
        self.coordinate = coordinate

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}

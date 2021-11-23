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

    var title: String?
    
    let placeName: String
    let locationName: String
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

    init(csStore: CSStoreModel) {
        self.title = csStore.place_name
        self.placeName = csStore.place_name
        self.locationName = csStore.address_name
        self.calloutImage = "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png"
        self.saleInfo = ""
        self.brand = csStore.categoryNameToBrand()
        self.coordinate = CLLocationCoordinate2D(
            latitude: Double(csStore.y)!,
            longitude: Double(csStore.x)!
        )

        super.init()
    }

    var subtitle: String? {
        return locationName
    }
}

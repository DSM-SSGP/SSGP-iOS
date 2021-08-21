//
//  MKMapView.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/14.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import MapKit
import RxSwift

extension MKMapView {
    /// 가장 가까운 Annotation 탐색
    func questNearestAnnotation() -> MKAnnotation? {
        var pins = self.annotations
        if let currentLocation = self.userLocation.location {
            for (index, pin) in pins.enumerated() where pin is MKUserLocation {
                pins.remove(at: index)
            }
            let nearestPin: MKAnnotation? = pins.reduce((CLLocationDistanceMax, nil)) { (nearest, pin) in
                let coord = pin.coordinate
                let loc = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                let distance = currentLocation.distance(from: loc)
                return distance < nearest.0 ? (distance, pin) : nearest
            }.1
            return nearestPin
        }
        return nil
    }
}

//
//  MapViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import MapKit

import RxSwift
import RxCocoa

class MapViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let output = Output()

    private var isTrackingMode = true
    private var isMapFirstLoad = true

    struct Input {
        let mapViewDidFinishLoadingMap: Driver<Void>
        let annotaationIsSelected: Driver<MKAnnotationView?>
        let annotaationIsDeselected: Driver<Void>
        let userDraggedMapView: Driver<Void>
        let userMoved: Driver<Void>
    }

    struct Output {
        let setAnnotataion = PublishRelay<StoreAnnotation>()
        let moveMyLocation = PublishRelay<Void>()
        let selectNearestAnnotation = PublishRelay<Void>()
        let deselecteAllAnnotataion = PublishRelay<Void>()
        let showFloatingPanel = PublishRelay<StoreAnnotation>()
        let hideFloatingPanel = PublishRelay<Void>()
    }

    func transform(_ input: Input) -> Output {

        // 맵뷰가 처음 로드 되었을때 트랙킹모드를 활설화시킨다.
        input.mapViewDidFinishLoadingMap.asObservable().subscribe(onNext: { [weak self] in
            if self?.isMapFirstLoad ?? false {
                self?.isMapFirstLoad = false
                self?.isTrackingMode = true
                self?.setAnnotataion()
            }
        })
        .disposed(by: disposeBag)

        // annotation이 선택되었을때
        input.annotaationIsSelected.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] annotataionView in
                if annotataionView?.annotation is MKUserLocation {
                    self?.isTrackingMode = true
                    self?.output.moveMyLocation.accept(())
                    self?.output.selectNearestAnnotation.accept(())
                } else if let storeAnnotataion = annotataionView?.annotation as? StoreAnnotation {
                    self?.output.showFloatingPanel.accept(storeAnnotataion)
                }
            })
            .disposed(by: disposeBag)

        // 어노테이션 선택 해제시
        input.annotaationIsDeselected.asObservable().subscribe(onNext: { [weak self] in
            self?.output.hideFloatingPanel.accept(())
        })
        .disposed(by: disposeBag)

        // mapView가 user에 의해 drag 될때
        input.userDraggedMapView.asObservable().subscribe(onNext: { [weak self] in
            self?.isTrackingMode = false
            self?.output.deselecteAllAnnotataion.accept(())
        })
        .disposed(by: disposeBag)

        // user가 움직였을때
        input.userMoved.asObservable()
            .filter { self.isTrackingMode }
            .subscribe(onNext: { [weak self] in
                self?.output.moveMyLocation.accept(())
                self?.output.selectNearestAnnotation.accept(())
            })
        .disposed(by: disposeBag)

        return output
    }
}

extension MapViewModel {
    private func setAnnotataion() {
        // demo data
        output.setAnnotataion.accept(
            StoreAnnotation(
                identifier: 1,
                title: "CU 대덕대정곡관점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "1 + 1",
                brand: .cu,
                coordinate: CLLocationCoordinate2D(
                    latitude: 36.390328,
                    longitude: 127.363910)
            )
        )
        output.setAnnotataion.accept(
            StoreAnnotation(
                identifier: 2,
                title: "CU 대덕대생활관점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "2 + 1",
                brand: .cu,
                coordinate: CLLocationCoordinate2D(
                    latitude: 36.389698,
                    longitude: 127.367955)
            )
        )
        output.setAnnotataion.accept(
            StoreAnnotation(
                identifier: 3,
                title: "CU 대덕대카페테리아점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "1 + 1",
                brand: .cu,
                coordinate: CLLocationCoordinate2D(
                    latitude: 36.390816,
                    longitude: 127.367692)
            )
        )
    }
}

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
    var disposeBag = DisposeBag()
    var output = Output()

    private var isTrackingMode = true
    private var isMapFirstLoad = true

    struct Input {
        let viewWillApear: Driver<Void>
        let userLocationIsEnabled: Single<CLLocationCoordinate2D>
        let mapViewDidFinishLoadingMap: Driver<Void>
        let annotaationIsSelected: Driver<MKAnnotationView?>
        let annotaationIsDeselected: Driver<Void>
        let userDraggedMapView: Driver<Void>
        let userMoved: Driver<Void>
    }

    struct Output {
        let setAnnotataion = PublishRelay<[StoreAnnotation]>()
        let moveMyLocation = PublishRelay<Void>()
        let selectNearestAnnotation = PublishRelay<Void>()
        let deselecteAllAnnotataion = PublishRelay<Void>()
        let showFloatingPanel = PublishRelay<StoreAnnotation>()
        let hideFloatingPanel = PublishRelay<Void>()
    }

    func transform(_ input: Input) -> Output {

        input.userLocationIsEnabled.subscribe(onSuccess: {
            HTTPClient.shared.networking(api: .findNearbyStore(
                String($0.longitude),
                String($0.latitude)
            ), model: [CSStoreModel].self)
                .subscribe(onSuccess: {
                    self.setAnnotataion(csStores: $0)
                })
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        // 맵뷰가 처음 로드 되었을때 트랙킹모드를 활성화시킨다.
        input.mapViewDidFinishLoadingMap.asObservable().subscribe(onNext: { [weak self] in
            if self?.isMapFirstLoad ?? false {
                self?.isMapFirstLoad = false
                self?.isTrackingMode = true
            }
        })
        .disposed(by: disposeBag)

        // annotation이 선택되었을때
        input.annotaationIsSelected.asObservable()
            .observe(on: MainScheduler.asyncInstance)
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
    private func setAnnotataion(csStores: [CSStoreModel]) {
        let annotations = csStores.map {
            StoreAnnotation(csStore: $0)
        }
        self.output.setAnnotataion.accept(annotations)
    }
}

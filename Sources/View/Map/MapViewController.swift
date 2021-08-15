//
//  MapViewController.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

class MapViewController: UIViewController {

    // MARK: - Properties
    private let disposeBag = DisposeBag()

    private var isTrackingMode = true

    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.startUpdatingLocation()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
    }
    private lazy var mapView = MKMapView().then {
        $0.delegate = self
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        $0.showsUserLocation = true
        $0.showsCompass = false
        $0.setUserTrackingMode(.follow, animated: true)
        $0.register(
            StoreMarkerView.self,
            forAnnotationViewWithReuseIdentifier: "MKMapViewDefaultAnnotationViewReuseIdentifier"
        )
    }
    private let noticeButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "bell.fill")
        $0.tintColor = R.color.notSelectedIcon()
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setupSubview()
        moveMyLocation(animated: false)
        bind()

    }

    // MARK: - private method

    private func bind() {
        // demo data
        setAnnotation(
            annotation: StoreAnnotation(
                identifier: 1,
                title: "이마트24 순천신대에듀점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "1 + 1",
                brand: .emart24,
                coordinate: CLLocationCoordinate2D(
                    latitude: 34.939765,
                    longitude: 127.547760)
            )
        )
        setAnnotation(
            annotation: StoreAnnotation(
                identifier: 2,
                title: "CU 에듀힐스점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "2 + 1",
                brand: .cu,
                coordinate: CLLocationCoordinate2D(
                    latitude: 34.939043,
                    longitude: 127.545247)
            )
        )
        setAnnotation(
            annotation: StoreAnnotation(
                identifier: 3,
                title: "GS25 순천신대점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "1 + 1",
                brand: .gs25,
                coordinate: CLLocationCoordinate2D(
                    latitude: 34.939772,
                    longitude: 127.548598)
            )
        )
        setAnnotation(
            annotation: StoreAnnotation(
                identifier: 3,
                title: "CU 순천신대중앙점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "1 + 1",
                brand: .cu,
                coordinate: CLLocationCoordinate2D(
                    latitude: 34.933748,
                    longitude: 127.549066)
            )
        )
        setAnnotation(
            annotation: StoreAnnotation(
                identifier: 3,
                title: "GS25 신대메가타운점",
                locationName: nil,
                discipline: nil,
                calloutImage: "https://i.ibb.co/gS2kj1X/5d6fee703b00009605cd1bad-1.png",
                saleInfo: "1 + 1",
                brand: .gs25,
                coordinate: CLLocationCoordinate2D(
                    latitude: 34.935942,
                    longitude: 127.545467)
            )
        )
    }

    private func setupSubview() {
        self.view.addSubview(mapView)

        mapView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(15)
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = noticeButton
    }

}

// MARK: - MKMapView
extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    private func moveMyLocation(animated: Bool) {
        isTrackingMode = true
        locationManager.userLocation().subscribe(onSuccess: { [weak self] in
            let viewRegion = MKCoordinateRegion(
                center: $0,
                latitudinalMeters: 800,
                longitudinalMeters: 800
            )
            self?.mapView.setRegion(viewRegion, animated: animated)
        })
        .disposed(by: disposeBag)
    }

    private func setAnnotation(annotation: StoreAnnotation) {
        annotation.calloutView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                print(annotation.identifier)
            })
            .disposed(by: annotation.disposeBag)
        self.mapView.addAnnotation(annotation)
    }

    private func selectNearestAnnotataion() {
        if let nearestAnnotation = mapView.questNearestAnnotation() {
            mapView.selectAnnotation(
                nearestAnnotation,
                animated: true
            )
        }
    }

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        isTrackingMode = true
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            mapView.deselectAnnotation(view.annotation, animated: false)
            moveMyLocation(animated: true)
            selectNearestAnnotataion()
        }
    }

    // mapView가 drag 될때
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated {
            isTrackingMode = false
        }
    }

    // User Locationd에 변화가 있을 때
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isTrackingMode {
            moveMyLocation(animated: true)
            selectNearestAnnotataion()
        }
    }

}

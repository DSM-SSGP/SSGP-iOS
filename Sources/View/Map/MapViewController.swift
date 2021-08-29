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
import FloatingPanel

class MapViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private var isTrackingMode = true
    private var isMapFirstLoad = true

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
    private lazy var noticeButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "bell.fill")
        $0.tintColor = R.color.notSelectedIcon()
        $0.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigateToNotificationViewController()
        })
        .disposed(by: self.disposeBag)
    }
    let floatingPanelController = FloatingPanelController().then {
        $0.surfaceView.appearance.backgroundColor = R.color.background()?.withAlphaComponent(0.9)
        $0.surfaceView.appearance.cornerRadius = 8.0
        $0.layout = StoreDetailFloatingPanelLayout()
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setupSubview()
        moveMyLocation(animated: false)
        bind()
        setFloatingPanel()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }

    // MARK: - private method

    private func bind() {
        // demo data
        setAnnotation(
            annotation: StoreAnnotation(
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
        setAnnotation(
            annotation: StoreAnnotation(
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
        setAnnotation(
            annotation: StoreAnnotation(
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

    private func setupSubview() {
        self.view.addSubview(mapView)

        mapView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(15)
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
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
        if isMapFirstLoad {
            isTrackingMode = true
            isMapFirstLoad = false
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            mapView.deselectAnnotation(view.annotation, animated: false)
            moveMyLocation(animated: true)
            selectNearestAnnotataion()
        } else if let storeAnnotataion = view.annotation as? StoreAnnotation {
            hideFloatingPanel()
            showFloatingPanel(selectedAnnotation: storeAnnotataion)
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

// MARK: - FloatingPanel
extension MapViewController: FloatingPanelControllerDelegate {
    private func setFloatingPanel() {
        let contentViewcontroller = StoreDetailFloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.set(contentViewController: contentViewcontroller)
        floatingPanelController.addPanel(toParent: self)
    }

    private func showFloatingPanel(selectedAnnotation: StoreAnnotation) {
        // 플로팅 판넬 데이터 바인딩
        if let ftp = floatingPanelController.contentViewController as? StoreDetailFloatingPanelController {
            ftp.bind()
        }
        floatingPanelController.move(to: .half, animated: true)
    }

    private func hideFloatingPanel() {
        floatingPanelController.move(to: .hidden, animated: true)
    }
}

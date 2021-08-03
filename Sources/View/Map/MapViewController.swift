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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private lazy var locationManager = CLLocationManager().then {
        $0.delegate = self
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.requestWhenInUseAuthorization()
        $0.startUpdatingLocation()
    }
    private let mapView = MKMapView().then {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        $0.showsUserLocation = true
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
        moveMyLocation()

    }

    // MARK: - private method

    private func bind() {
        // demo data
        setAnnotation(latitudeValue: <#T##CLLocationDegrees#>,
                      longitudeValue: <#T##CLLocationDegrees#>,
                      title: <#T##String#>,
                      subtitle: <#T##String#>)
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

    private func moveMyLocation() {
        locationManager.userLocation().subscribe(onSuccess: { [weak self] in
            let viewRegion = MKCoordinateRegion(
                center: $0,
                latitudinalMeters: 700,
                longitudinalMeters: 700
            )
            self?.mapView.setRegion(viewRegion, animated: true)
            self?.mapView.setUserTrackingMode(.follow, animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func setAnnotation(latitudeValue: CLLocationDegrees,
                               longitudeValue: CLLocationDegrees,
                               delta span: Double = 0.1,
                               title strTitle: String,
                               subtitle strSubTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        self.mapView.addAnnotation(annotation)
    }

}

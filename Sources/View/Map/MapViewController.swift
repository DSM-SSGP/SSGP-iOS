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

    private let viewModel = MapViewModel()
    private let disposeBag = DisposeBag()

    private let mapViewDidFinishLoadingMap = PublishSubject<Void>()
    private let annotaationIsSelected = PublishSubject<MKAnnotationView?>()
    private let annotaationIsDeselected = PublishSubject<Void>()
    private let userDraggedMapView = PublishSubject<Void>()
    private let userMoved = PublishSubject<Void>()

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
        let input = MapViewModel.Input(
            userLocationIsEnabled: self.locationManager.userLocation(),
            mapViewDidFinishLoadingMap: mapViewDidFinishLoadingMap.asDriver(onErrorJustReturn: ()),
            annotaationIsSelected: annotaationIsSelected.asDriver(onErrorJustReturn: nil),
            annotaationIsDeselected: annotaationIsDeselected.asDriver(onErrorJustReturn: ()),
            userDraggedMapView: userDraggedMapView.asDriver(onErrorJustReturn: ()),
            userMoved: userMoved.asDriver(onErrorJustReturn: ())
        )
        let output = viewModel.transform(input)

        output.setAnnotataion.subscribe(onNext: { [weak self] annotations in
            self?.mapView.addAnnotations(annotations)
        })
        .disposed(by: disposeBag)

        output.moveMyLocation
            .subscribe(onNext: { [weak self] in
                self?.moveMyLocation(animated: true)
            })
            .disposed(by: disposeBag)

        output.selectNearestAnnotation.subscribe(onNext: { [weak self] in
            self?.selectNearestAnnotataion()
        })
        .disposed(by: disposeBag)

        output.showFloatingPanel.subscribe(onNext: { [weak self] annotation in
            self?.showFloatingPanel(selectedAnnotation: annotation)
        })
        .disposed(by: disposeBag)

        output.hideFloatingPanel.subscribe(onNext: { [weak self] in
            self?.hideFloatingPanel()
        })
        .disposed(by: disposeBag)

        output.deselecteAllAnnotataion.subscribe(onNext: { [weak self] in
            self?.mapView.deselectAnnotation(self?.mapView.selectedAnnotations.last, animated: true)
        })
        .disposed(by: disposeBag)
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
        locationManager.userLocation()
            .subscribe(onSuccess: { [weak self] in
                let viewRegion = MKCoordinateRegion(
                    center: $0,
                    latitudinalMeters: 800,
                    longitudinalMeters: 800
                )
                self?.mapView.setRegion(viewRegion, animated: animated)
            })
            .disposed(by: disposeBag)
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
        self.mapViewDidFinishLoadingMap.onNext(())
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.annotaationIsSelected.onNext(view)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.annotaationIsDeselected.onNext(())
    }

    // mapView가 drag 될때
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if !animated { userDraggedMapView.onNext(()) }
    }

    // User Locationd에 변화가 있을 때
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userMoved.onNext(())
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
            ftp.bind(selectedAnnotation: selectedAnnotation)
        }
        floatingPanelController.move(to: .half, animated: true)
    }

    private func hideFloatingPanel() {
        floatingPanelController.move(to: .hidden, animated: true)
    }
}

//
//  StoreMarkerView.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/05.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxGesture
import Nuke

class StoreMarkerView: MKMarkerAnnotationView {

    private let diposeBag = DisposeBag()
    private var title: String?

    override var annotation: MKAnnotation? {
        willSet {
            guard let store = newValue as? StoreAnnotation else {
                return
            }
            configure(for: store)
            configureCalloutView(for: store)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        guard let store = self.annotation as? StoreAnnotation else {
            return
        }

        // calloutView에 title이 표시되지 않기위함.
        if selected {
            store.title = ""
        } else {
            store.title = self.title
        }
    }

    func configure(for annotation: StoreAnnotation) {
        displayPriority = .required
        self.title = annotation.title
        glyphImage = annotation.brand.fitAnnotaionImage()
        markerTintColor = annotation.brand.fitColor()
    }

    func configureCalloutView(for annotation: StoreAnnotation) {
        canShowCallout = true
        detailCalloutAccessoryView = annotation.calloutView

        let imageView = UIImageView().then {
            $0.backgroundColor = .white
            $0.contentMode = .scaleAspectFit
            if let url  = URL(string: annotation.calloutImage) {
                Nuke.loadImage(with: url,
                               options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                               into: $0)
            }
        }
        let saleInfoLabel = UILabel().then {
            $0.textColor = annotation.brand.fitColor()
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.text = annotation.saleInfo
        }

        annotation.calloutView.addSubview(imageView)
        annotation.calloutView.addSubview(saleInfoLabel)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        saleInfoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(5)
        }
    }
}

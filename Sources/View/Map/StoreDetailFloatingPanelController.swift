//
//  StoreDetailFloatingPanelController.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/24.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FloatingPanel

class StoreDetailFloatingPanelController: UIViewController {

    // MARK: - Properties
    private let storeBrandImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 20)
    }
    private let addressLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10)
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
    }

    // MARK: - Public Method
    public func bind(selectedAnnotation: StoreAnnotation) {
        storeBrandImageView.image = selectedAnnotation.brand.fitImage()
        nameLabel.text = selectedAnnotation.placeName
        addressLabel.text = selectedAnnotation.locationName
    }

    // MARK: - Private Method
    private func setupSubview() {
        self.view.addSubview(storeBrandImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(addressLabel)

        storeBrandImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.centerY.equalTo(self.view.snp.top).offset(75)
            $0.width.height.equalTo(80)
        }
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(storeBrandImageView.snp.right).offset(15)
            $0.bottom.equalTo(storeBrandImageView.snp.centerY)
        }
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(storeBrandImageView.snp.right).offset(15)
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
        }
    }

}

class StoreDetailFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition  = .bottom
    let initialState: FloatingPanelState = .hidden
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(absoluteInset: 150, edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}

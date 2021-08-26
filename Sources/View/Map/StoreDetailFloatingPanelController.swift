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
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Private Method
    private func setupSubview() {
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

//
//  ProductDetailViewModel.swift
//  SSGP
//
//  Created by 장서영 on 2021/12/02.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductDetailViewModel: ViewModel {

    let disposeBag = DisposeBag()
    let output = Output()

    init(productId: String) {
        HTTPClient.shared.networking(
            api: .productDetail(productId),
            model: ProductResponse.self
        ).subscribe(onSuccess: { response in
            self.output.productDetail.onNext(response.selling ?? [])
        }, onFailure: { error in
            print(error)
        }).disposed(by: self.disposeBag)
    }

    struct Input {
    }

    struct Output {
        var productDetail = PublishSubject<[Selling]>()
    }

    func transform(_ input: Input) -> Output {

        return output
    }
}

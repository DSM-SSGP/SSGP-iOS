//
//  ProductListViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductListViewModel: ViewModel {

    let disposeBag = DisposeBag()
    var output = Output()

    struct Input {
        let getPopularLists: Driver<Void>
        let getRecommendLists: Driver<Void>
        let getLowPriceLists: Driver<Void>
        let likeButtonIsTapped: Driver<Void>
        let productPostIsTapped: Driver<String>
    }

    struct Output {
        var getLists = PublishRelay<[ProductList]>()
        var detailID = PublishRelay<String>()
        var result = PublishRelay<String>()
    }

    func transform(_ input: Input) -> Output {
        input.getPopularLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(api: .popularityList,
                                         model: [ProductList].self)
                .subscribe(onSuccess: { _ in
                    self.output.getLists
                })
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        return output
    }
}

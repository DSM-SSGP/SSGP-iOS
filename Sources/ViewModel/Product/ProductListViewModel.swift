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
    let output = Output()

    struct Input {
        let getPopularLists: Signal<Void>
        let getRecommendLists: Signal<Void>
        let getLowPriceLists: Signal<Void>
        let likeButtonIsTapped: Signal<Void>
        let productPostIsTapped: Signal<String>
    }

    struct Output {
        let getLists: Driver<[ProductList]>
        let detailID: Driver<String>
        let result: Signal<String>
    }

    func transform(_ input: Input) -> Output {
        let getList = PublishRelay<[ProductList]>()
        let getDetailRow = PublishSubject<String>()
        let result = PublishSubject<String>()

        input.getPopularLists.asObservable().subscribe(onNext: { listData in
            HTTPClient.shared.networking(api: .popularityList, model: [ProductList])
                .subscribe(onNext: { data in
                    switch data {
                    case .success:
                        getList.accept(data)
                    case .failure:
                        result.onNext("로드 실패")
                    }
                }).disposeBag(by: self.disposeBag)
        }).disposeBag(by: disposeBag)
        return Output(getLists: getList.asDriver(onErrorJustReturn: []),
                      detailID: getDetailRow.asDriver(onErrorJustReturn:""),
                      result: result.asSignal(onErrorJustReturn: ""))
    }
}

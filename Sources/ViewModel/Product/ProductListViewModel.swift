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
import KeychainSwift

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
    }

    func transform(_ input: Input) -> Output {
        return output
    }
}

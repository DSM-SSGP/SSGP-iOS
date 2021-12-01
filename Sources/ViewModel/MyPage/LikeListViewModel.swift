//
//  LikeListViewModel.swift
//  SSGP
//
//  Created by 장서영 on 2021/12/01.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LikeListViewModel: ViewModel {

    let disposeBag = DisposeBag()
    let output = Output()

    struct Input {
        var getlikedList: Driver<Void>
    }

    struct Output {
        var likedList = PublishSubject<[ProductResponse]>()
    }

    func transform(_ input: Input) -> Output {
        input.getlikedList.asObservable()
            .subscribe(onNext: {
                HTTPClient.shared.networking(
                    api: .likeList,
                    model: [ProductResponse].self
                ).subscribe(onSuccess: { response in
                    self.output.likedList.onNext(response)
                }, onFailure: { error in
                    print(error)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        return output
    }
}

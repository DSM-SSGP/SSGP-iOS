//
//  MyPageViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MyPageViewModel: ViewModel {

    let disposeBag = DisposeBag()
    let output = Output()

    struct Input {
        var confirmButtonIsTapped: Driver<String>
    }

    struct Output {
        var changePasswordResult = PublishRelay<Bool>()
    }

    func transform(_ input: Input) -> Output {
        input.confirmButtonIsTapped.asObservable().subscribe(onNext: { pwd in
            HTTPClient.shared.networking(
                api: .updatePassword(pwd),
                model: EmptyModel.self
            ).subscribe(onSuccess: { _ in
                self.output.changePasswordResult.accept(true)
            }, onFailure: { error in
                print(error)
                self.output.changePasswordResult.accept(false)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        return output
    }
}

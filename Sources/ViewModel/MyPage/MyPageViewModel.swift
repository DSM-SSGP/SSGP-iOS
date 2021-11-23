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
import KeychainSwift

class MyPageViewModel: ViewModel {

    let disposeBag = DisposeBag()
    let output = Output()

    struct Input {
        let logOutButtonIsTapped: Driver<Void>
        let notificationSwitchIsOn: Driver<Void>
    }

    struct Output {
        var logOutResult = PublishRelay<Bool>()
    }

    func transform(_ input: Input) -> Output {
        input.logOutButtonIsTapped.asObservable()
            .subscribe(
                onNext: {
                    KeychainSwift().delete("ACCESS-TOKEN")
                }
            ).disposed(by: disposeBag)
        
        return output
    }
}

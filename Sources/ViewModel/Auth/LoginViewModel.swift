//
//  LoginViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/08/31.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModel {

    let disposeBag = DisposeBag()
    let output = Output()

    struct Input {
        let loginButtonIsTapped: Driver<(id: String, pwd: String)>
    }

    struct Output {
        let loginResult = PublishRelay<String>()
    }

    func transform(_ input: Input) -> Output {
        return output
    }
}

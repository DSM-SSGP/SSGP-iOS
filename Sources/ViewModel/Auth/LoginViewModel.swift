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
import KeychainSwift

class LoginViewModel: ViewModel {

    let disposeBag = DisposeBag()
    var output = Output()

    private let keychain = KeychainSwift()

    struct Input {
        let loginButtonIsTapped: Driver<(id: String, pwd: String)>
    }

    struct Output {
        var loginResult = PublishRelay<Bool>()
    }

    func transform(_ input: Input) -> Output {
        input.loginButtonIsTapped.asObservable().subscribe(onNext: { id, pwd in
            HTTPClient.shared.networking(
                api: .login(id, pwd),
                model: TokenModel.self
            ).subscribe(onSuccess: { token in
                self.keychain.set(token.access_token, forKey: "ACCESS-TOKEN")
                self.keychain.set(token.refresh_token, forKey: "REFRESH-TOKEN")
                self.keychain.set(id, forKey: "ID")
                self.keychain.set(pwd, forKey: "PASSWORD")
                self.output.loginResult.accept(true)
            }, onFailure: { _ in
                self.output.loginResult.accept(false)
            })
            .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)

        return output
    }
}

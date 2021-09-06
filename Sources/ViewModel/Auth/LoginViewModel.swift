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
import AuthenticationServices

class LoginViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let output = Output()

    struct Input {
        let appleIdLinked: PublishSubject<ASAuthorizationAppleIDCredential>
    }

    struct Output {
    }

    func transform(_ input: Input) -> Output {
        input.appleIdLinked.asObservable().subscribe(onNext: { userInfo in
            print(userInfo.authorizationCode ?? "empty authorizationCode")
            print(userInfo.authorizedScopes)
            print(userInfo.email ?? "empty email")
            print(userInfo.fullName ?? "empty fullname")
            print(userInfo.identityToken ?? "empty identityToken")
            print(userInfo.realUserStatus)
        })
        .disposed(by: disposeBag)
        return output
    }
}

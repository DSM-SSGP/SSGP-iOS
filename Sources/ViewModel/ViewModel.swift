//
//  ViewModel.swift
//  SSGP
//
//  Created by 김수완 on 2021/07/26.
//  Copyright © 2021 com.ssgp. All rights reserved.
//

import Foundation
import RxSwift

protocol ViewModel: AnyObject {
    var disposeBag: DisposeBag { get }
    var output: Output {get}

    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}

/*
 
 기본적인 ViewModel의 틀입니다.
 
 import RxSwift

 class SomeViewModel: ViewModel {
     let disposeBag = DisposeBag()
     let output = Output()

     struct Input {
     }

     struct Output {
     }

     func transform(_ input: Input) -> Output {
        return output
     }
 }
 
 */

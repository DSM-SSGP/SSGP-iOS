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
import Alamofire

class ProductListViewModel: ViewModel {

    let disposeBag = DisposeBag()
    var output = Output()

    struct Input {
        let getPopularLists: Driver<Void>
        let getRecommendLists: Driver<Void>
        let getLowPriceLists: Driver<Void>
       // let likeButtonIsTapped: Driver<Void>
       // let productPostIsTapped: Driver<String>
        let searchProductIsTapped: Driver<String>
    }

    struct Output {
        var getLists = PublishSubject<[ProductResponse]>()
        var gs25Lists = PublishSubject<[ProductResponse]>()
        var cuLists = PublishSubject<[ProductResponse]>()
        var miniStopLists = PublishSubject<[ProductResponse]>()
        var sevenElevenLists = PublishSubject<[ProductResponse]>()
        var emart24Lists = PublishSubject<[ProductResponse]>()

        var productDetail = PublishSubject<[ProductResponse]>()
        var likeresult = PublishSubject<Bool>()
    }

    func transform(_ input: Input) -> Output {
        input.searchProductIsTapped.asObservable()
            .subscribe(onNext: { searchWord in
                HTTPClient.shared.networking(
                    api: .searchProduct(searchWord),
                    model: Search.self
                ).subscribe(onSuccess: { response in
                    self.storeFiltering(model: response.application_responses)
                }, onFailure: { error in
                    print(error)
                }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)

//        input.productPostIsTapped.asObservable()
//            .subscribe(onNext: { id in
//                HTTPClient.shared.networking(
//                    api: .productDetail(id),
//                    model: [ProductResponse].self
//                ).subscribe(onSuccess: { response in
//                    self.output.productDetail.onNext(response)
//                }, onFailure: { error in
//                    print(error)
//                }).disposed(by: self.disposeBag)
//            }).disposed(by: disposeBag)

        input.getPopularLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(
                api: .popularityList,
                model: [ProductResponse].self
            ).subscribe(onSuccess: { response in
                self.storeFiltering(model: response)
            }, onFailure: { error in
                print(error)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.getRecommendLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(
                api: .recommendationList,
                model: [ProductResponse].self
            ).subscribe(onSuccess: { response in
                self.storeFiltering(model: response)
            }, onFailure: { error in
                print(error)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        input.getLowPriceLists.asObservable().subscribe(onNext: {
            HTTPClient.shared.networking(
                api: .lowestList,
                model: [ProductResponse].self
            ).subscribe(onSuccess: { response in
                self.storeFiltering(model: response)
            }, onFailure: { error in
                print(error)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)

        return output
    }

    private func storeFiltering(model: [ProductResponse]) {
        var gs25List = [ProductResponse]()
        var cuList = [ProductResponse]()
        var miniStopList = [ProductResponse]()
        var sevenElevenList = [ProductResponse]()
        var emart24List = [ProductResponse]()

        model.forEach { item in
            item.brands.forEach {
                switch $0 {
                case "GS25":
                    gs25List.append(item)
                case "CU":
                    cuList.append(item)
                case "MIMISTOP":
                    miniStopList.append(item)
                case "Seven Eleven":
                    sevenElevenList.append(item)
                case "emart24":
                    emart24List.append(item)
                default:
                    break
                }
            }
        }

        output.gs25Lists.onNext(gs25List)
        output.cuLists.onNext(cuList)
        output.miniStopLists.onNext(miniStopList)
        output.sevenElevenLists.onNext(sevenElevenList)
        output.emart24Lists.onNext(emart24List)
        output.getLists.onNext(model)
    }
}

//
//  ViewModel.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 8.05.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var input : Input { get }
    var output : Output { get }
}

class ViewModel: ViewModelType {
    var input: ViewModel.Input
    var output: ViewModel.Output
    
    struct Input {
        let country: AnyObserver<String>
        let selectedObjectIds: AnyObserver<[Int]>
    }

    struct Output {
        let objectIds: Driver<[Int]>
        let allObjects: Driver<[Object]>
    }
    
    var countrySubject = ReplaySubject<String>.create(bufferSize: 1)
    var selectedObjectIdsSubject = ReplaySubject<[Int]>.create(bufferSize: 1)
    
    init() {
        let objectIds = countrySubject
            .flatMap {
                NetworkService.shared.getQueryObjects(withCountryName: $0)
                        .compactMap { $0?.objectIDs }
            }
            
        
        let first = selectedObjectIdsSubject
            .flatMap {
                NetworkService.shared.getObject(withObjectId: $0[0])
            }
        
        let second = selectedObjectIdsSubject
            .flatMap {
                NetworkService.shared.getObject(withObjectId: $0[1])
            }
        
        let third = selectedObjectIdsSubject
            .flatMap {
                NetworkService.shared.getObject(withObjectId: $0[2])
            }
        
        let fourth = selectedObjectIdsSubject
            .flatMap {
                NetworkService.shared.getObject(withObjectId: $0[3])
            }
        
        let fifth = selectedObjectIdsSubject
            .flatMap {
                NetworkService.shared.getObject(withObjectId: $0[4])
            }
        
        let sixth = selectedObjectIdsSubject
            .flatMap {
                NetworkService.shared.getObject(withObjectId: $0[5])
            }
        
        let all = Observable.combineLatest(first, second, third, fourth, fifth, sixth)
            .map {
                return [$0.0, $0.1, $0.2, $0.3, $0.4, $0.5].compactMap {$0}
            }
        
        input = Input(country: countrySubject.asObserver(),
                           selectedObjectIds: selectedObjectIdsSubject.asObserver())
        
        output = Output(objectIds: objectIds.asDriver(onErrorJustReturn: []),
                        allObjects: all.asDriver(onErrorJustReturn: []))
    }
}

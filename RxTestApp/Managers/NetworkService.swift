//
//  NetworkService.swift
//  RxTestApp
//
//  Created by Mert Tuzer on 7.05.2021.
//

import Foundation
import RxSwift

class NetworkService {
    static let shared = NetworkService()
    
    private let baseURLString = "https://collectionapi.metmuseum.org/public/collection/v1/"
    
    private func getAPIData<T: Decodable>(country: String?, object: Int?) -> Observable<T?> {
        
        var urlString = ""
        if let country = country {
            urlString = baseURLString + "search?dateBegin=1500&dateEnd=1900&q=\(country)"
        } else if let object = object {
            urlString = baseURLString + "objects/\(object)"
        } else {
            return Observable.just(nil)
        }
        
        return Observable.create { observer -> Disposable in
            
            guard let url = URL(string: urlString) else {

                return Disposables.create {
                    observer.onNext(nil)
                }
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, _, error in
                let decoder = JSONDecoder()
                guard let data = data, let decodedData = try? decoder.decode(T.self, from: data) else {
                    observer.onNext(nil)
                    return
                }
                observer.onNext(decodedData)
            }
            task.resume()
            
            return Disposables.create {
                observer.onCompleted()
                task.cancel()
            }
        }
    }
    
    func getQueryObjects(withCountryName country: String) -> Observable<QueryObjects?> {
        return getAPIData(country: country, object: nil)
    }
    
    func getObject(withObjectId id: Int) -> Observable<Object?> {
        return getAPIData(country: nil, object: id)
    }
}

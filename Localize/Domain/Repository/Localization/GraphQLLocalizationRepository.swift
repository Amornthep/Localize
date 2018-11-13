//
//  GraphQLLocalizationRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation
import Apollo
import RxSwift

public class GraphQLLocalizationRepository: ILocalizationRepository {
    private var apollo:ApolloClient?
    
    public init(host:String){
        let url = URL(string: host)!
        self.apollo = ApolloClient(url: url)
    }
    
    public func get(namespace: String, language: String, result: @escaping (LocalizeList) -> Void) throws {
        apolloGetText(namespace: namespace, language: language)
            .subscribe(
                onNext: { localizeList in
                    result(localizeList)
                },
                onError: { error in
//                    throw LocalizeError.loadException(code: ErrorCode.UNABLE_TO_LOAD_CODE, message: "\(error)")
                }
            )
            .disposed(by: DisposeBag())
    }
    
    private func apolloGetText(namespace: String, language: String) -> Observable<LocalizeList> {
        return Observable.create { observer -> Disposable in
            let query = GetProductQuery(name: "", desc: "", price: 0, image: "")
            self.apollo?.fetch(query:  query){
                [weak self](res, error) in
                
                self?.handelError(res: res, error: error as NSError?, result: { (res, error) in
                    if let error = error{
                        observer.onError(error)
                    }else{
                       observer.onNext(LocalizeList())
                    }
                })
            }
            return Disposables.create()
        }
    }
    
    private func handelError<T>(res:GraphQLResult<T>?,error:NSError?, result: @escaping (GraphQLResult<T>?,NSError?) -> Void){
        if let res = res, let error = res.errors?[0] as NSError?{
            result(res, error)
        }else if let error = error as NSError?{
            result(res, error)
        }else{
            result(res,error)
        }
    }
}

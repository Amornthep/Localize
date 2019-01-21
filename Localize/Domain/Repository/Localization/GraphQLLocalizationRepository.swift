//
//  GraphQLLocalizationRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation
import Apollo

public class GraphQLLocalizationRepository: ILocalizationRepository {
    
    private var apollo:ApolloClient?
    
    public init(host:String){
        let url = URL(string: host)!
        self.apollo = ApolloClient(url: url)
    }
    
    public func getLastModify(namespace: String, result: @escaping ([String : Double]?, NSError?) -> Void) {
        
    }
    
    public func get(namespace: String, language: String , result: @escaping (LocalizeData?, NSError?) -> Void){
        let query = GetProductQuery(name: "", desc: "", price: 0, image: "")
        self.apollo?.fetch(query:  query){
            [weak self](res, error) in
            self?.handelError(res: res, error: error as NSError?, result: { (res, error) in
                if let error = error{
                    result(nil , error)
                }else{
                  result(LocalizeData() , nil)
                }
            })
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

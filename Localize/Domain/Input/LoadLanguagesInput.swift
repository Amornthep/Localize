//
//  LoadLanguagesInput.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 23/1/2562 BE.
//  Copyright © 2562 Amornthep. All rights reserved.
//

import CoreFoundation

public struct LoadLanguagesInput {
    let namespace:String!
    let limit:Int!
    let nextToken:String?
    
    func validate() throws{
        if namespace == "" || limit == 0 {
            throw LocalizeError.invalidInputException(code: ErrorCode.INVALID_PARAM_CODE, message: ErrorMessage.INVALID_PARAMETER_MESSAGE)
        }
    }
    
    public init(namespace:String, limit:Int, nextToken:String?) {
        self.namespace = namespace
        self.limit = limit
        self.nextToken = nextToken
    }
}

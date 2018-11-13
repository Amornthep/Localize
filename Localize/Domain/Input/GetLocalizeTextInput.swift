//
//  GetLocalizeTextInput.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public struct GetLocalizeTextInput {
    let key:String!
    let language:String!
    
    public init(key:String, language:String) {
        self.key = key
        self.language = language
    }
    
    func validate() throws{
        if key == "" {
            throw LocalizeError.invalidInputException(code: ErrorCode.INVALID_KEY_CODE, message: ErrorMessage.INVALID_KEY_MESSAGE)
        }
        if language == ""{
            throw LocalizeError.invalidInputException(code: ErrorCode.INVALID_LANGUAGE_CODE, message: ErrorMessage.INVALID_LANGUAGE_MESSAGE)
        }
    }
}

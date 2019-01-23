//
//  LoadLanguageInput.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public struct LoadLanguageInput {
    let languageId:String!
    
    func validate() throws{
        if languageId == ""{
            throw LocalizeError.invalidInputException(code: ErrorCode.INVALID_LANGUAGE_CODE, message: ErrorMessage.INVALID_LANGUAGE_MESSAGE)
        }
    }
    
    public init(languageId:String) {
        self.languageId = languageId
    }
}


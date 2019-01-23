//
//  LocalizeError.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public enum ErrorCode:String{
    case INVALID_LANGUAGE_CODE = "localization_invalid_language"
    case INVALID_KEY_CODE = "localization_invalid_key"
    case INVALID_PARAM_CODE = "localization_invalid_parameter"
    case UNABLE_TO_SAVE_CACHE_CODE = "localization_unable_to_save_cache"
    case UNABLE_TO_LOAD_CODE = "localization_unable_to_load"
}

public enum ErrorMessage:String{
    case INVALID_LANGUAGE_MESSAGE = "Invalid language"
    case INVALID_KEY_MESSAGE = "Invalid key"
    case INVALID_PARAMETER_MESSAGE = "Invalid Parameter"
    case UNABLE_TO_SAVE_CACHE_MESSAGE = "Unable to save cache"
}

public enum LocalizeError: Error {
    case invalidInputException(code: ErrorCode ,message:ErrorMessage)
    case cacheException(code: ErrorCode ,message:ErrorMessage)
}


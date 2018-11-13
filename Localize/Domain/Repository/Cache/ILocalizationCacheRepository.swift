//
//  ILocalizationCacheRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public protocol ILocalizationCacheRepository{
    func getText(key:String, language:String) ->String
    func save(localizeList: LocalizeList)
    func isLanguageExist(language:String) ->Bool
}

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
    func saveLocalizeData(localizeData: LocalizeData, result: @escaping (NSError?) -> Void)
    func getLocalizeData(language: String)->LocalizeData?
    func saveLastModify(data:[String:Double])
    func getLastModify()->[String:Double]?
    func isLanguageExist(language:String) ->Bool
}

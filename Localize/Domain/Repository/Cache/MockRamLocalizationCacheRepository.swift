//
//  RamLocalizationCacheRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

class MockRamLocalizationCacheRepository: ILocalizationCacheRepository {
    var localizeList:[String:LocalizeData] = [:]
    var lastModify:[String:Double]?
    var saveCount = 0
    public func saveLocalizeData(localizeData: LocalizeData, result: @escaping (NSError?) -> Void) {
        if let language = localizeData.language{
            if language == "fr"{
                return result(NSError(domain: "LocalizationCache", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_SAVE_CACHE_CODE.rawValue]))
            }
            self.localizeList[language] = localizeData
            result(nil)
        }else{
            result(NSError(domain: "LocalizationCache", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_SAVE_CACHE_CODE.rawValue]))
        }
        saveCount += 1
    }
    
    public func getLocalizeData(language: String) -> LocalizeData? {
        return localizeList[language]
    }
    
    public func saveLastModify(data: [String : Double]) {
        lastModify = data
    }
    
    func getLastModify() -> [String : Double]? {
        return lastModify
    }
    
    public func getText(key: String, language: String) -> String {
        if let localizeData = localizeList[language], let text = localizeData.data[key]{
            return text
        }
        return key
    }
    
    public func isLanguageExist(language: String) -> Bool {
        return localizeList[language] != nil
    }
}

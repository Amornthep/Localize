//
//  RamLocalizationCacheRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

class RamLocalizationCacheRepository: ILocalizationCacheRepository {
    var localizeList:LocalizeList?
    
    public func getText(key: String, language: String) -> String {
        if let localize = self.localizeList?.data[language], let text = localize[key]{
            return text
        }
        return key
    }
    
    public func save(localizeList: LocalizeList) {
        for (language, data) in localizeList.data {
            self.localizeList?.data.updateValue(data, forKey: language)
        }
    }
    
    public func isLanguageExist(language: String) -> Bool {
        copyInRam()
        return localizeList?.data[language] != nil
    }
    
    func copyInRam(){
        if localizeList == nil {
            localizeList = LocalizeList()
        }
    }
}

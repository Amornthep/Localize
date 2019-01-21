//
//  UserDefaultLocalizationCacheRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public class UserDefaultLocalizationCacheRepository: ILocalizationCacheRepository {
    let LOCALIZE_KEY = "Localize"
    let LAST_MODIFY_KEY = "LastModify"
    var localizeList:[String:LocalizeData] = [:]
    
    public func saveLocalizeData(localizeData: LocalizeData, result: @escaping (NSError?) -> Void) {
        if let language = localizeData.language{
            self.localizeList[language] = localizeData
            UserDefaults.standard.set(localizeData, forKey: LOCALIZE_KEY+language)
            result(nil)
        }else{
            result(NSError(domain: "LocalizationCache", code: 0, userInfo: ["code":"localization_unable_to_save_cache"]))
        }
    }
    
    public func getLocalizeData(language: String) -> LocalizeData? {
        return UserDefaults.standard.object(forKey: LOCALIZE_KEY+language) as? LocalizeData
    }
    
    public func saveLastModify(data: [String : Double]) {
        UserDefaults.standard.set(data, forKey: LAST_MODIFY_KEY)
    }
    
    public func getLastModify() -> [String : Double]? {
        return UserDefaults.standard.object(forKey: LAST_MODIFY_KEY) as? [String : Double]
    }
    
    public func getText(key: String, language: String) -> String {
        if let localizeData = localizeList[language], let text = localizeData.data[key]{
            return text
        }
        return key
    }
    
    public func isLanguageExist(language: String) -> Bool {
        copyInRam(language: language)
        return localizeList[language] != nil
    }
    
    func copyInRam(language: String){
        let localizeData = UserDefaults.standard.object(forKey: LOCALIZE_KEY+language) as? LocalizeData
        if let localizeData = localizeData {
            localizeList[language] = localizeData
        }
    }
}

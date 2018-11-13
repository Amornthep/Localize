//
//  LocalizeService.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public class LocalizeService: ILocalizeService {
    private var localizationCacheRepository:ILocalizationCacheRepository!
    private var localizationRepository:ILocalizationRepository!
    private var namespace:String!
    private var defaultLanguage:String!
    
    public func getLocalizeText(input: GetLocalizeTextInput) throws -> String {
        try input.validate()
        var text = localizationCacheRepository.getText(key: input.key, language: input.language)
        if text == input.key {
            self.postEvent(eventHandler: EventHandler.ON_KEY_NOT_EXIST, userInfo: [input.language:input.key])
            text = localizationCacheRepository.getText(key: input.key, language: defaultLanguage)
            if text == input.key {
                self.postEvent(eventHandler: EventHandler.ON_KEY_NOT_EXIST, userInfo: [defaultLanguage:input.key])
            }
        }
        return text
    }
    
    public func loadLanguage(input: LoadLanguageInput) throws {
        try input.validate()
        
        if !localizationCacheRepository.isLanguageExist(language: defaultLanguage){
            try localizationRepository.get(namespace: namespace, language: defaultLanguage) {[weak self] (localizeList) in
                self?.localizationCacheRepository.save(localizeList: localizeList)
            }
        }
        
        if defaultLanguage == input.language{
            return
        }
        
        if !localizationCacheRepository.isLanguageExist(language: input.language){
            try localizationRepository.get(namespace: namespace, language: input.language) {[weak self] (localizeList) in
                self?.localizationCacheRepository.save(localizeList: localizeList)
                self?.postEvent(eventHandler: EventHandler.ON_LOAD_LANGUAGE_SUCCESS, userInfo: ["language":input.language])
            }
        }
    }
    
    private func postEvent(eventHandler: EventHandler, userInfo:[AnyHashable : Any]?){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: eventHandler.rawValue), object: nil, userInfo: userInfo)
    }
    
    public func unRegisterEventHandler(_ observer: Any, eventHandler: EventHandler) {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: eventHandler.rawValue),
                                                          object: nil)
    }
    
    public func registerEventHandler(_ observer: Any, selector aSelector: Selector, eventHandler: EventHandler) {
        NotificationCenter.default.addObserver(observer, selector: aSelector, name: NSNotification.Name(rawValue: eventHandler.rawValue), object: nil)
    }
    
    public init(defaultLanguage: String, namespace: String, localizationRepository: ILocalizationRepository, localizationCacheRepository: ILocalizationCacheRepository){
        self.namespace = namespace
        self.defaultLanguage = defaultLanguage
        self.localizationCacheRepository = localizationCacheRepository
        self.localizationRepository = localizationRepository
    }
}

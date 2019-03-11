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
    let LANGUAGE = "language"
    public func getLocalizeText(input: GetLocalizeTextInput) throws -> String {
        try input.validate()
        var text = localizationCacheRepository.getText(key: input.key, language: input.languageId)
        if text == input.key {
            self.postEvent(eventHandler: EventHandler.ON_KEY_NOT_EXIST, userInfo: [input.languageId:input.key])
            text = localizationCacheRepository.getText(key: input.key, language: defaultLanguage)
            if text == input.key {
                self.postEvent(eventHandler: EventHandler.ON_KEY_NOT_EXIST, userInfo: [defaultLanguage:input.key])
            }
        }
        return text
    }
    
    private func saveLocalize(localizeData:LocalizeData, result: @escaping (NSError?) -> Void){
        localizationCacheRepository.saveLocalizeData(localizeData: localizeData, result: {
            [weak self] error in
            guard let language = localizeData.language, let languageKey = self?.LANGUAGE else{
                return
            }
            if let error = error{
                self?.postEvent(eventHandler: EventHandler.ON_LOAD_LANGUAGE_FAIL, userInfo: [languageKey:language])
                result(error)
            }else {
                self?.postEvent(eventHandler: EventHandler.ON_LOAD_LANGUAGE_SUCCESS, userInfo: [languageKey:language])
                result(nil)
            }
        })
    }
    
    private func getLocalizeAndSave(language:String, result: @escaping (NSError?) -> Void){
        localizationRepository.get(language: language) {[weak self] (localizeData, error) in
            if let error = error , let languageKey = self?.LANGUAGE{
                self?.postEvent(eventHandler: EventHandler.ON_LOAD_LANGUAGE_FAIL, userInfo: [languageKey:language])
                result(error)
            }else if let localizeData = localizeData{
                self?.saveLocalize(localizeData: localizeData, result: result)
            }
        }
    }
    
    private func compareLanguageNeedUpdate(lastModify:[String:Double], localizeData:LocalizeData)->Bool{
        if let language = localizeData.language, let lastmodifyInCache = localizeData.lastModify, let languageLastModify = lastModify[language]{
            return lastmodifyInCache < languageLastModify
        }
        return true
    }
    
    public func loadLanguages(input: LoadLanguagesInput, result: @escaping (LanguageList?, NSError?) -> Void) throws {
        try input.validate()
        localizationRepository.getLanguages(namespace: input.namespace, limit: input.limit, nextToken: input.nextToken, result: result)
    }
    
    public func loadLanguage(input: LoadLanguageInput, result: @escaping (NSError?) -> Void) throws {
        try input.validate()
        if let localizeData = localizationCacheRepository.getLocalizeData(language: input.languageId) {
            if let lastModify = localizationCacheRepository.getLastModify(){
                if compareLanguageNeedUpdate(lastModify: lastModify, localizeData: localizeData){
                    getLocalizeAndSave(language: input.languageId, result: result)
                }else{
                    result(nil)
                }
            }else{
                localizationRepository.getLastModify(namespace: namespace) {[weak self] (lastModify, error) in
                    if error != nil{
                        self?.postEvent(eventHandler: EventHandler.ON_LOAD_LASTMODIFY_FAIL, userInfo:nil)
                        result(nil)
                    }else if let lastModify = lastModify{
                        self?.localizationCacheRepository.saveLastModify(data: lastModify)
                        if self?.compareLanguageNeedUpdate(lastModify: lastModify, localizeData: localizeData) ?? false{
                            self?.getLocalizeAndSave(language: input.languageId, result: result)
                        }else{
                            result(nil)
                        }
                    }
                }
            }
        }else{
            getLocalizeAndSave(language: input.languageId, result: result)
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

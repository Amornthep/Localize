//
//  ILocalizeService.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public protocol ILocalizeService {
    func getLocalizeText(input:GetLocalizeTextInput) throws ->String
    func loadLanguage(input: LoadLanguageInput, result: @escaping (NSError?) -> Void) throws
    func loadLanguages(input: LoadLanguagesInput, result: @escaping (LanguageList?, NSError?) -> Void) throws
    func registerEventHandler(_ observer: Any, selector aSelector: Selector, eventHandler: EventHandler)
    func unRegisterEventHandler(_ observer: Any, eventHandler: EventHandler)
}

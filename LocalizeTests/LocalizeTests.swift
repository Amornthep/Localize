//
//  LocalizeTests.swift
//  LocalizeTests
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import XCTest
@testable import Localize

class LocalizeTests: XCTestCase {
    
    var localizeService:ILocalizeService?
    var ramCacheRepo:ILocalizationCacheRepository?
    
    override func setUp() {
        if localizeService == nil {
            let mockLocalizationRepo = MockLocalizationRepository()
            ramCacheRepo = MockRamLocalizationCacheRepository()
            localizeService = LocalizeService(defaultLanguage: "en", namespace: "sellconnect", localizationRepository: mockLocalizationRepo, localizationCacheRepository: ramCacheRepo!)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidate() {
        do {
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: ""), result: {_ in})
        } catch LocalizeError.invalidInputException(let code, _) {
            XCTAssertEqual(code, ErrorCode.INVALID_LANGUAGE_CODE)
            return
        } catch {
            XCTFail()
        }
        XCTFail()
    }
    
    func testValidateLanguages() {
        do {
            try localizeService?.loadLanguages(input: LoadLanguagesInput(namespace: "", limit: 0, nextToken: nil), result: { _,_  in})
        } catch LocalizeError.invalidInputException(let code, _) {
            XCTAssertEqual(code, ErrorCode.INVALID_PARAM_CODE)
            return
        } catch {
            XCTFail()
        }
        XCTFail()
    }
    
    func testLoadLanguagesFail(){
        do {
            try localizeService?.loadLanguages(input: LoadLanguagesInput(namespace: "false", limit: 10, nextToken: nil), result: { (list, error) in
                XCTAssertNotNil(error)
            })
        } catch {
            XCTFail()
        }
    }
    
    func testLoadLanguages(){
        do {
            try localizeService?.loadLanguages(input: LoadLanguagesInput(namespace: "true", limit: 10, nextToken: nil), result: { (list, error) in
                XCTAssertNil(error)
            })
        } catch {
            XCTFail()
        }
    }
    
    func testLoadNewLanguageFail(){
        do {
            var language:String?
            let handler = { (notification: Notification) -> Bool in
                language = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "th0"), result:{
                error in
                XCTAssertEqual(error?.userInfo["code"] as? String, ErrorCode.UNABLE_TO_LOAD_CODE.rawValue)
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(language, "th0")
        } catch {
            XCTFail()
        }
    }
    
    func testLoadNewLanguageSuccess(){
        do {
            var language:String?
            let handler = { (notification: Notification) -> Bool in
                language = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_SUCCESS.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {_ in})
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(language, "en")
        } catch {
            XCTFail()
        }
    }
    
    func testSaveNewLanguageFail() {
        do {
            var language:String?
            let handler = { (notification: Notification) -> Bool in
                language = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "fr"), result: {
                error in
                XCTAssertEqual(error?.userInfo["code"] as? String, ErrorCode.UNABLE_TO_SAVE_CACHE_CODE.rawValue)
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(language, "fr")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateLanguageFail() {
        do {
            var language:String?
            let handler = { (notification: Notification) -> Bool in
                language = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "th"), result: {
                error in
            })
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "th"), result: {
                error in
                XCTAssertEqual(error?.userInfo["code"] as? String, ErrorCode.UNABLE_TO_LOAD_CODE.rawValue)
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(language, "th")
        } catch {
            XCTFail()
        }
    }
    
    func testUpdateLanguageSuccess() {
        do {
            var language:String?
            let handler = { (notification: Notification) -> Bool in
                language = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_SUCCESS.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {
                error in
            })
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {
                error in
                XCTAssertNil(error)
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(language, "en")
        } catch {
            XCTFail()
        }
    }
    
    func testSaveUpdateLanguageFail() {
        do {
            var language:String?
            ramCacheRepo?.saveLastModify(data: ["fr":2.0])
            ramCacheRepo?.saveLocalizeData(localizeData: LocalizeData(data: ["a":"a"], lastModify: 1.0, language: "fr" , languageId:"fr"), result: {_ in
            })
            let handler = { (notification: Notification) -> Bool in
                language = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "fr"), result: {
                error in
                XCTAssertEqual(error?.userInfo["code"] as? String, ErrorCode.UNABLE_TO_SAVE_CACHE_CODE.rawValue)
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(language, "fr")
        } catch {
            XCTFail()
        }
    }
    
    func testGetlastModifyFail(){
        let mockLocalizationRepo = MockLocalizationRepository()
        ramCacheRepo = MockRamLocalizationCacheRepository()
        localizeService = LocalizeService(defaultLanguage: "en", namespace: "", localizationRepository: mockLocalizationRepo, localizationCacheRepository: ramCacheRepo!)
        
        do {
            var notificationCall = false
            ramCacheRepo?.saveLocalizeData(localizeData: LocalizeData(data: ["a":"a"], lastModify: 1.0, language: "en", languageId:"en"), result: {_ in
            })
            let handler = { (notification: Notification) -> Bool in
                notificationCall = true
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LASTMODIFY_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {
                error in
                XCTAssertNil(error)
            })
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(notificationCall, true)
        } catch {
            XCTFail()
        }
    }
    
    func testGetLanguageSuccess(){
        do {
            ramCacheRepo?.saveLastModify(data: ["en":1.0])
            ramCacheRepo?.saveLocalizeData(localizeData: LocalizeData(data: ["a":"a"], lastModify: 1.0, language: "en", languageId:"en"), result: {_ in
            })
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {
                error in
                XCTAssertNil(error)
            })
            let test = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "a", languageId: "en"))
            XCTAssertEqual(test, "a")
        } catch {
            XCTFail()
        }
    }
    
    func testGetLastModifyAndGetLanguageSuccess(){
        do {
            ramCacheRepo?.saveLocalizeData(localizeData: LocalizeData(data: ["a":"a"], lastModify: 1.0, language: "en", languageId:"en"), result: {_ in
            })
             XCTAssertNil(ramCacheRepo?.getLastModify())
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {
                error in
                XCTAssertNil(error)
            })
            let test = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "a", languageId: "en"))
            XCTAssertNotNil(ramCacheRepo?.getLastModify())
            XCTAssertEqual(test, "a")
        } catch {
            XCTFail()
        }
    }
    
    func testGetLastModifyAndSaveUpdateFail(){
        do {
            var languageNoti:String?
            let handler = { (notification: Notification) -> Bool in
                languageNoti = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            
            ramCacheRepo?.saveLocalizeData(localizeData: LocalizeData(data: ["a":"a"], lastModify: 1.0, language: "fr", languageId:"fr"), result: {_ in
            })
            XCTAssertNil(ramCacheRepo?.getLastModify())
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "fr"), result: {
                error in
                XCTAssertEqual(error?.userInfo["code"] as? String, ErrorCode.UNABLE_TO_SAVE_CACHE_CODE.rawValue)
            })
            let test = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "a", languageId: "fr"))
            XCTAssertEqual(test, "a")
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(languageNoti, "fr")
        } catch {
            XCTFail()
        }
    }
    
    func testGetLastModifyAndUpdateSuccess(){
        do {
            var languageNoti:String?
            let handler = { (notification: Notification) -> Bool in
                languageNoti = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_SUCCESS.rawValue),
                        object: nil,
                        handler: handler)
            
            ramCacheRepo?.saveLocalizeData(localizeData: LocalizeData(data: ["a":"a"], lastModify: 0.0, language: "en", languageId:"fr"), result: {_ in
            })
            XCTAssertNil(ramCacheRepo?.getLastModify())
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "en"), result: {
                error in
                XCTAssertNil(error)
            })
            let test = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "hello", languageId: "en"))
            XCTAssertEqual(test, "Hello")
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(languageNoti, "en")
        } catch {
            XCTFail()
        }
    }
    
    func testGetLastModifyAndUpdateFail(){
        do {
            var languageNoti:String?
            let handler = { (notification: Notification) -> Bool in
                languageNoti = notification.userInfo?["language"] as? String
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_FAIL.rawValue),
                        object: nil,
                        handler: handler)
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "th"), result: {
                error in
                XCTAssertNil(error)
            })
            ramCacheRepo?.saveLastModify(data: ["th":0.0])
            try localizeService?.loadLanguage(input: LoadLanguageInput(languageId: "th"), result: {
                error in
                XCTAssertNotNil(error)
            })
            let test = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "hello", languageId: "th"))
            XCTAssertEqual(test, "สวัสดี")
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(languageNoti, "th")
        } catch {
            XCTFail()
        }
    }
    
}

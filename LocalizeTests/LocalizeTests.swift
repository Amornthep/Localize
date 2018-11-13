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
    
    override func setUp() {
        if localizeService == nil {
            let mockLocalizationRepo = MockLocalizationRepository()
            let ramCacheRepo = RamLocalizationCacheRepository()
            localizeService = LocalizeService(defaultLanguage: "en", namespace: "", localizationRepository: mockLocalizationRepo, localizationCacheRepository: ramCacheRepo)
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidate() {
        do {
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: ""))
        } catch LocalizeError.invalidInputException(let code, _) {
            XCTAssertEqual(code, ErrorCode.INVALID_LANGUAGE_CODE)
            return
        } catch {
            XCTFail()
        }
        XCTFail()
    }
    
    func testSaveCacheRepository() {
        do {
            var notificationCall = false
            let handler = { (notification: Notification) -> Bool in
                notificationCall = true
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_LOAD_LANGUAGE_SUCCESS.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: "th"))
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(notificationCall, true)
        } catch {
            XCTFail()
        }
    }
    
    func testGetLocalizeFailed() {
        do {
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: "gg"))
        } catch LocalizeError.loadException(let code, _) {
            return XCTAssertEqual(code, ErrorCode.UNABLE_TO_LOAD_CODE)
        } catch {
            XCTFail()
        }
        XCTFail()
    }
    
    func testValidateGetInput(){
        do {
            let _ = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "product_not_found", language: ""))
        } catch LocalizeError.invalidInputException(let code, let message) {
            XCTAssertEqual(code, ErrorCode.INVALID_LANGUAGE_CODE)
            XCTAssertEqual(message, ErrorMessage.INVALID_LANGUAGE_MESSAGE)
        } catch {
            XCTFail()
        }
        
        do {
            let _ = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "", language: "en"))
        } catch LocalizeError.invalidInputException(let code, let message) {
            XCTAssertEqual(code, ErrorCode.INVALID_KEY_CODE)
            XCTAssertEqual(message, ErrorMessage.INVALID_KEY_MESSAGE)
            return
        } catch {
            XCTFail()
        }
        XCTFail()
    }
    
    func testGetTextSuccess(){
        do {
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: "en"))
            let text = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "product_not_found", language: "en"))
            XCTAssertEqual(text, "Product not found")
        } catch {
            XCTFail()
        }
    }
    
    func testGetTHTextSuccess(){
        do {
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: "th"))
            let text = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "product_not_found", language: "th"))
            XCTAssertEqual(text, "ไม่พบสินค้า")
        } catch {
            XCTFail()
        }
    }
    
    func testGetTextDefaultSuccess(){
        do {
            var notificationCall = false
            let handler = { (notification: Notification) -> Bool in
                notificationCall = true
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_KEY_NOT_EXIST.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: "th"))
            let text = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "thankyou", language: "th"))
            XCTAssertEqual(text, "Thank You")
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(notificationCall, true)
        } catch {
            XCTFail()
        }
    }
    
    func testGetDefaultFail(){
        do {
            var notificationCall = false
            let handler = { (notification: Notification) -> Bool in
                notificationCall = true
                return true
            }
            expectation(forNotification:NSNotification.Name(rawValue: EventHandler.ON_KEY_NOT_EXIST.rawValue),
                        object: nil,
                        handler: handler)
            
            try localizeService?.loadLanguage(input: LoadLanguageInput(language: "th"))
            let text = try localizeService?.getLocalizeText(input: GetLocalizeTextInput(key: "product_out_of_stock", language: "th"))
            
            XCTAssertEqual(text, "product_out_of_stock")
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(notificationCall, true)
            
        } catch {
            XCTFail()
        }
    }
}

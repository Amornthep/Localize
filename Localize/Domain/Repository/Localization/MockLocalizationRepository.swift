//
//  MockLocalizationRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

class MockLocalizationRepository: ILocalizationRepository {
    var loadcount = 0
    func getLastModify(namespace: String, result: @escaping ([String : Double]?, NSError?) -> Void) {
        if namespace == "sellconnect"{
            if loadcount == 1{
                let res = ["en":2.0, "th":2.0, "fr":2.0, "vn":2.0]
                return  result(res , nil)
            }
            let res = ["en":1.0, "th":1.0, "fr":1.0, "vn":1.0]
            result(res , nil)
        }else{
            result(nil , NSError(domain: "Localize", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_LOAD_CODE.rawValue,"Message":"Namespace Notfound"]))
        }
    }
    
    func get(language: String , result: @escaping (LocalizeData?, NSError?) -> Void) {
        let localizeList = LocalizeData()
        localizeList.language = language
        if language == "en"{
            localizeList.data = ["hello":"Hello","thankyou":"Thank You","product_not_found":"Product not found"]
        }else if language == "th"{
            if loadcount == 1{
                return result(nil , NSError(domain: "Localize", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_LOAD_CODE.rawValue,"Message":"Language Notfound"]))
            }
            localizeList.data = ["hello":"สวัสดี", "product_not_found":"ไม่พบสินค้า"]
            loadcount += 1
        }else if language == "vn"{
            localizeList.data = ["hello":"สวัสดี", "product_not_found":"ไม่พบสินค้า"]
        }else if language == "fr"{
            localizeList.data = ["hello":"สวัสดี", "product_not_found":"ไม่พบสินค้า"]
        }else{
            return result(nil , NSError(domain: "Localize", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_LOAD_CODE.rawValue,"Message":"Language Notfound"]))
        }
        result(localizeList , nil)
    }
    
    func getLanguages(namespace: String, limit: Int, nextToken: String?, result: @escaping (LanguageList?, NSError?) -> Void) {
        if namespace != "false"{
            let languageList = LanguageList(languages: [Language(languageId: "en", language: "English")], nextToken: "a")
            result(languageList, nil)
        }else{
            result(nil , NSError(domain: "Localize", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_LOAD_CODE.rawValue,"Message":"Language Notfound"]))
        }
    }
}

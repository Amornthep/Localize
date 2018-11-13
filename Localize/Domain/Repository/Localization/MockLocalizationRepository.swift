//
//  MockLocalizationRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

class MockLocalizationRepository: ILocalizationRepository {
    func get(namespace: String, language: String, result: @escaping (LocalizeList) -> Void) throws {
        let localizeList = LocalizeList()
        
        if language == "en"{
            localizeList.data[language] = ["hello":"Hello","thankyou":"Thank You","product_not_found":"Product not found"]
        }else if language == "th"{
            localizeList.data[language] = ["hello":"สวัสดี", "product_not_found":"ไม่พบสินค้า"]
        }else if language == "vn"{
            
        }else{
            throw LocalizeError.loadException(code: ErrorCode.UNABLE_TO_LOAD_CODE, message: "Language Notfound")
        }
        result(localizeList)
    }

}

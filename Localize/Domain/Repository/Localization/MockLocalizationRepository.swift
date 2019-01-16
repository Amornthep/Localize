//
//  MockLocalizationRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

class MockLocalizationRepository: ILocalizationRepository {
    func getLastModify(namespace: String, result: @escaping ([String : String]?, NSError?) -> Void) {
        if namespace == "sellconnect"{
            let res = ["en":"000000", "th":"000000000"]
            result(res , nil)
        }else{
            result(nil , NSError(domain: "Localize", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_LOAD_CODE.rawValue,"Message":"Namespace Notfound"]))
        }
    }
    
    func get(namespace: String, language: String , result: @escaping (LocalizeList?, NSError?) -> Void) {
        let localizeList = LocalizeList()
        
        if language == "en"{
            localizeList.data[language] = ["hello":"Hello","thankyou":"Thank You","product_not_found":"Product not found"]
        }else if language == "th"{
            localizeList.data[language] = ["hello":"สวัสดี", "product_not_found":"ไม่พบสินค้า"]
        }else if language == "vn"{
            
        }else{
            return result(nil , NSError(domain: "Localize", code: 0, userInfo: ["code":ErrorCode.UNABLE_TO_LOAD_CODE.rawValue,"Message":"Language Notfound"]))
        }
        result(localizeList , nil)
    }

}

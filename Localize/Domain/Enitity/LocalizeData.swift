//
//  LocalizeList.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public class LocalizeData: NSObject, NSCoding {
    open var data:[String:String] = [:]
    open var lastModify:Double?
    open var language:String?
    open var languageId:String?
    
    override init(){
        
    }
    
    public init(data:[String:String], lastModify:Double, language:String){
        self.data = data
        self.lastModify = lastModify
        self.language = language
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let data = aDecoder.decodeObject(forKey: "data") as! [String:String]
        let lastModify = aDecoder.decodeObject(forKey: "lastModify") as! Double
        let language = aDecoder.decodeObject(forKey: "language") as! String
        self.init(data: data, lastModify:lastModify, language:language)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: "data")
        aCoder.encode(lastModify, forKey: "lastModify")
        aCoder.encode(language, forKey: "language")
    }
    
}

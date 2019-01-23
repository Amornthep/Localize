//
//  LanguageList.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 23/1/2562 BE.
//  Copyright © 2562 Amornthep. All rights reserved.
//

import CoreFoundation

public class LanguageList: NSObject, NSCoding {
    open var languages:[Language]?
    open var nextToken:String?
    
    override init(){
        
    }
    
    public init(languages:[Language], nextToken:String){
        self.languages = languages
        self.nextToken = nextToken
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let languages = aDecoder.decodeObject(forKey: "languages") as! [Language]
        let nextToken = aDecoder.decodeObject(forKey: "nextToken") as! String
        self.init(languages:languages, nextToken:nextToken)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(languages, forKey: "languages")
        aCoder.encode(nextToken, forKey: "nextToken")
    }
}

public class Language: NSObject, NSCoding {
    open var languageId:String?
    open var language:String?
    
    override init(){
        
    }
    
    public init(languageId:String, language:String){
        self.languageId = languageId
        self.language = language
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let languageId = aDecoder.decodeObject(forKey: "languageId") as! String
        let language = aDecoder.decodeObject(forKey: "language") as! String
        self.init(languageId: languageId, language:language)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(languageId, forKey: "languageId")
        aCoder.encode(language, forKey: "language")
    }
}

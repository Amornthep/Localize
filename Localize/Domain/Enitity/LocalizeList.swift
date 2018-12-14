//
//  LocalizeList.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public class LocalizeList: NSObject, NSCoding {
    var data:[String:[String:String]] = [:]
    
    override init(){
        
    }
    
    init(data:[String:[String:String]]){
        self.data = data
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let data = aDecoder.decodeObject(forKey: "data") as! [String:[String:String]]
        self.init(data: data)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: "data")
    }
    
    public func getData()->[String:[String:String]]{
        return self.data
    }
}

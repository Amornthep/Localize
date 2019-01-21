//
//  ILocalizationRepository.swift
//  Localize
//
//  Created by Amornthep Chuaiam on 12/11/2561 BE.
//  Copyright © 2561 Amornthep. All rights reserved.
//

import CoreFoundation

public protocol ILocalizationRepository {
    func get(namespace: String, language: String , result: @escaping (LocalizeData?, NSError?) -> Void)
    func getLastModify(namespace: String, result: @escaping ([String:Double]?, NSError?) -> Void)
}

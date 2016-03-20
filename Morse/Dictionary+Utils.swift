//
//  Dictionary+Utils.swift
//  Morse
//
//  Created by J.R.Hoem on 29.09.15.
//  Copyright © 2015 JRH. All rights reserved.
//

import Foundation


extension Dictionary {

    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
    
}

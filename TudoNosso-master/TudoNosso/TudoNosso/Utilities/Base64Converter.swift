//
//  Base64Converter.swift
//  WhatsappClone
//
//  Created by Bruno Cardoso Ambrosio on 02/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class Base64Converter {
    static func encodeStringAsBase64(_ text:String) -> String{
        guard let data = text.data(using: .utf8) else {
            print("Could not encode data!")
            return ""
        }
        let base64 = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return base64
    }
    
    static func decodeBase64AsString(_ text:String) -> String{
        guard let decodedData = Data(base64Encoded: text) else {
            print("Could not decode data!")
            return ""
        }
        let decodedString = String(data: decodedData, encoding: .utf8)!
        
        return decodedString
    }
}

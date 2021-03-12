//  Date+extensions.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 05/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.

import Foundation

extension Date{
    
    /// Convert a Date to a String in the format yyyy-MM-dd HH:mm:ss
    public func toString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
 
        let result = formatter.string(from: self)
        return result
        
    }
    
    
    /// Convert this Date to a String in the  specified format
    /// - Parameter dateFormat: The format of the output
    public func toString(dateFormat: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat

        let result = formatter.string(from: self)
        return result
        
    }
    
    /// Convert a String to a Date if the format specified on call was correct, else nil
    /// - Parameters:
    ///   - string: The string that contains a Date
    ///   - dateFormat: The format of the Date in the string
    static func fromString(string:String, dateFormat: String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let date = formatter.date(from: string)
        return date
        
    }
}

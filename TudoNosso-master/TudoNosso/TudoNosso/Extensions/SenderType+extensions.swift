//
//  SenderType+extensions.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 22/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import MessageKit

extension SenderType {
    var initials:String{
        let names = displayName.split(separator: " ")
        var initials = ""
        names.forEach { (name) in
            let index = name.index(name.startIndex, offsetBy: 1)
            let mySubstring = name[..<index] // Hello
            initials += String(mySubstring.uppercased())
        }
        
        return initials
    }
}

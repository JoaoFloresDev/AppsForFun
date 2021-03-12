//
//  DatabaseRepresentation.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 06/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation

/// The class that use this protocol will need to inform a how it is described in the database 
protocol DatabaseRepresentation {
    
    
    var representation: [String: Any] { get }

    
}



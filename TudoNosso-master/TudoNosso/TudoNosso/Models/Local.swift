//
//  Local.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 21/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation

class Local {

    static private var base: UserDefaults { return UserDefaults.standard }
    
    static var userMail: String? {
        set { base.set(newValue, forKey: "USER_MAIL") }
        get { return base.object(forKey: "USER_MAIL") as? String }
    }
    
    static var userKind: String? {
        set { base.set(newValue, forKey: "USER_KIND") }
        get { return base.object(forKey: "USER_KIND") as? String }
    }
}


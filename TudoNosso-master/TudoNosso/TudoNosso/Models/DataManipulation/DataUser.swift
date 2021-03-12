//
//  DataUserViewController.swift
//  TudoNosso
//
//  Created by Joao Flores on 04/12/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit
import CoreLocation

class DataUser {

    enum TypeOfProfile {
        case ong(Bool)
        case volunteer
        
        var isAddJobButtonHidden: Bool {
            switch self {
            case let .ong(myProfile):          return !myProfile
            case .volunteer:                 return true
            }
        }
        
        var segmentedControlTitle: String {
            switch self {
            case .ong:          return "Oportunidades"
            case .volunteer:    return "Participações"
            }
        }
        
        var isSegmentedControlHidden: Bool {
            switch self {
            case .ong:          return false
            case .volunteer:    return true
            }
        }
        
        var aboutTitle: String {
            switch self {
            case .ong:          return "Sobre a ONG"
            case .volunteer:    return "Sobre mim"
            }
        }
        
        var isAreasFieldHidden: Bool {
            switch self {
            case .ong:      return false
            default:        return true
            }
        }
    }
    
    var name: String?
    var address: String?
    var email: String?
    var description: String?
    var phone: String?
    var site: String?
    var facebook: String?
    var areas: [String]?
    var avatar: String?
    var typeOfProfile: TypeOfProfile?
    
    init(name: String, address: String, email: String, description: String?, phone: String?, site: String?, facebook: String?, areas: [String]?, avatar: String?, typeOfProfile: TypeOfProfile) {
        
        self.name = name
        self.address = address
        self.email = email
        self.description = description
        self.phone = phone
        self.site = site
        self.facebook = facebook
        self.areas = areas
        self.avatar = avatar
        self.typeOfProfile = typeOfProfile
    }

    init(name: String, address: String, email: String, description: String?, phone: String?, site: String?, facebook: String?, areas: [String]?, avatar: String?) {
        
        self.name = name
        self.address = address
        self.email = email
        self.description = description
        self.phone = phone
        self.site = site
        self.facebook = facebook
        self.areas = areas
        self.avatar = avatar
    }
}

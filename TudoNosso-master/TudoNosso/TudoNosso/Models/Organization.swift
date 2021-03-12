//
//  Onganization.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 06/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore.FIRGeoPoint

class Organization {
    
    var name: String
    var address: CLLocationCoordinate2D
    var email: String
    var desc: String?
    var phone: String?
    var site: String?
    var facebook: String?
    var areas: [String]?
    var avatar: String?
    
    init (name: String, address: CLLocationCoordinate2D, email: String){
        
        self.name = name
        self.address = address
        self.email = email
    }
    
    init (name: String, address: CLLocationCoordinate2D, desc: String?, email: String, phone: String?, site: String?, facebook: String?, areas:[String]?, avatar: String?){
        
        self.name = name
        self.address = address
        self.desc = desc
        self.email = email
        self.phone = phone
        self.site = site
        self.facebook = facebook
        self.areas = areas
        self.avatar = avatar
    }
    
    init?(snapshot: NSDictionary) {
        guard
            let name: String = Self.snapshotFieldReader(snapshot,.name),
            let email: String = Self.snapshotFieldReader(snapshot,.email),
            let location: GeoPoint = Self.snapshotFieldReader(snapshot,.address)
            else {
                return nil
        }
        self.name = name
        self.address = CLLocationCoordinate2D.fromGeoPoint(geoPoint: location)
        self.email = email
        self.desc = Self.snapshotFieldReader(snapshot,.description)
        self.phone = Self.snapshotFieldReader(snapshot,.phone)
        self.site = Self.snapshotFieldReader(snapshot,.site)
        self.facebook = Self.snapshotFieldReader(snapshot,.facebook)
        self.areas = Self.snapshotFieldReader(snapshot,.areas)
        self.avatar = Self.snapshotFieldReader(snapshot,.avatar)
    }
}

extension Organization: DatabaseRepresentation {
    typealias fieldEnum = OrganizationFields
    
    var representation: [String: Any] {
        var rep: [OrganizationFields : Any] = [
            .name: name,
            .address: address.toGeoPoint(),
            .email: email
        ]
        
        if let desc = self.desc {
            rep[.description] = desc
        }
        if let phone = self.phone {
            rep[.phone] = phone
        }
        if let site = self.site {
            rep[.site] = site
        }
        if let facebook = self.facebook {
            rep[.facebook] = facebook
        }
        if let areas = self.areas {
            rep[.areas] = areas
        }
        if let avatar = self.avatar{
            rep[.avatar] = avatar
        }
        
        return Dictionary(uniqueKeysWithValues: rep.map { key, value in
            (key.rawValue, value) })
    }
    
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary, _ field: OrganizationFields) -> T? {
        return snapshot[field.rawValue] as? T
    }
}

extension Organization: DictionaryInterpreter {
    static func interpret(data: NSDictionary) -> Self? {
        return Organization(snapshot: data) as? Self
    }
    
    
}

enum OrganizationFields: String, Hashable {
    case name = "ongName"
    case address
    case email
    case description = "desc"
    case phone
    case site
    case facebook
    case areas
    case avatar = "profilePic"
}

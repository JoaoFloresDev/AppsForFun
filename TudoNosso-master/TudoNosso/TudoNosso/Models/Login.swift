//
//  User.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 14/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Login {
    var id: String?
    var email: String
    var kind: LoginKinds
    var avatar: String?
    
    
    init(email: String, kind: LoginKinds){
        self.email = email
        self.kind = kind
    }
    
    init?(id:String,snapshot: NSDictionary) {
        
        guard
            let email: String = Self.snapshotFieldReader(snapshot, .email),
            let kind: String = Self.snapshotFieldReader(snapshot, .kind)
            else {
                return nil
        }
        guard let kindEnum = LoginKinds(rawValue: kind) else {return nil}
        self.id = id
        self.email = email
        self.kind = kindEnum
        self.avatar = Self.snapshotFieldReader(snapshot,.avatar)
        
    }
    
}

extension Login: DatabaseRepresentation {
    
    
    var representation: [String : Any] {
        var rep: [LoginFields : Any] = [
            .kind: kind.rawValue,
            .email: email
        ]
        
        if let avatar = self.avatar {
            rep[.avatar] = avatar
        }
        return Dictionary(uniqueKeysWithValues: rep.map { key, value in
            (key.rawValue, value) })
    }
    
    
}

extension Login: DictionaryInterpreter{
    typealias fieldEnum = LoginFields
    
    static func interpret(data: NSDictionary) -> Self? {
        if let id = data["id"] as? String {
            return Login(id: id, snapshot: data) as? Self
        }
        return nil
    }
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary,_ field: LoginFields) -> T?{
        return snapshot[field.rawValue] as? T
    }
}

enum LoginFields: String, Hashable  {
    case email = "email"
    case kind = "kind"
    case avatar = "profilePic"
    
}

enum LoginKinds: String, Hashable  {
    case ONG = "ong"
    case volunteer
}

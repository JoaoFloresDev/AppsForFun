//
//  User.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 22/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import MessageKit

class User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String
    var name: String
    var email: String
    var profileImage: String?
    var kind: String? = ""
    
    init(id: String, name: String, email:String, profileImage:String?) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
        
    }
    init?(snapshot: NSDictionary) {
        guard
        let email = snapshot["email"] as? String else {
                return nil
        }
        if let name = snapshot["volunteerName"] as? String {
            self.name = name
            
        }else if let name = snapshot["ongName"] as? String{
            self.name = name
        }else {return nil}
        
        self.id = Base64Converter.encodeStringAsBase64(email)
        self.email = email
        self.profileImage = snapshot["profilePic"] as? String
        
    }
    
    var representation: [String : Any] {
      var rep: [String : Any] = [
        "id": self.id,
        "name": self.name,
        "email": self.email,
      ]
      if let profileImage = self.profileImage{
        rep["profilePic"] = profileImage
      }
      return rep
    }
}



extension User: SenderType{
    var senderId: String {
        return id
    }
    
    var displayName: String {
        return name
    }
}

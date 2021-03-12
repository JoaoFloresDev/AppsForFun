//
//  Message.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 22/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
    var sender: SenderType {
        
        return user
    }
    var user: User
    var kind: MessageKind
    
    
    let id: String?
    let content: String
    let sentDate: Date
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    
    
    init(user: User, content: String) {
        self.user = user
        self.content = content
        self.kind = .text(content)
        self.sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Timestamp,
            let senderID = data["senderID"] as? String,
            let senderName = data["senderName"] as? String,
            let content = data["content"] as? String
            else {
                return nil
        }
        self.kind = .text(content)
        self.content = content
        id = document.documentID
        
        self.sentDate = sentDate.dateValue()
        let email = Base64Converter.decodeBase64AsString(senderID)
        self.user = User(id: senderID, name: senderName, email: email, profileImage: nil)
        
        
    }
    var representation: [String : Any] {
      let rep: [String : Any] = [
          "created": sentDate,
          "senderID": sender.senderId,
          "senderName": sender.displayName,
          "content": content
      ]

      
      return rep
    }
}




extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}

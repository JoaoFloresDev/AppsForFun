//
//  MessageDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 24/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MessageDM{
    let db = Firestore.firestore()
    var reference: CollectionReference?
    var messageListener: ListenerRegistration?
    
    init(channelID: String, completion: @escaping (DocumentChange) ->()){
        reference = db.collection(["channels", channelID, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                completion(change)
            }
        }
    }
    
    deinit {
          messageListener?.remove()
    }
    
    
    func save(_ message: Message, completion: @escaping ()->()) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            completion()
        }
    }
}

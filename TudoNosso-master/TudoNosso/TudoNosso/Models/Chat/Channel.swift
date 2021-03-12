//
//  Channel.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 22/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import FirebaseFirestore

enum ChannelFields: String, Hashable{
    case id
    case name
    case between
    case betweenKinds
}

class Channel {
    
    var id: String?
    let name: String
    var between: [String]
    var betweenKinds: [String]
    
    init(name: String, between: [String],betweenKinds: [String]) {
        id = nil
        self.name = name
        self.between = between
        self.betweenKinds = betweenKinds
        
    }
    
    init?(data: NSDictionary) {
        guard
            let id: String = Self.snapshotFieldReader(data,.id),
            let name: String = Self.snapshotFieldReader(data,.name),
            let between: [String] = Self.snapshotFieldReader(data,.between),
            let betweenKinds: [String] = Self.snapshotFieldReader(data,.betweenKinds)
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.between = between
        self.betweenKinds = betweenKinds
    }
    
}

extension Channel: DatabaseRepresentation {
    typealias fieldEnum = ChannelFields
    
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary, _ field: ChannelFields) -> T? {
        return snapshot[field.rawValue] as? T
    }
    var representation: [String : Any] {
        var rep: [ChannelFields : Any] = [
            .name: name,
            .between: between,
            .betweenKinds: betweenKinds
        ]
        
        
        if let id = id {
            rep[.id] = id
        }
        
        return Dictionary(uniqueKeysWithValues: rep.map({ (key, value) in
            (key.rawValue,value)
        }))
    }
    
}

extension Channel: DictionaryInterpreter{
    static func interpret(data: NSDictionary) -> Self? {
        return Channel(data: data) as? Self
    }
    
    
}

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name < rhs.name
    }
    
}



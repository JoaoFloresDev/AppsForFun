//
//  OrganizationDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 07/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

class OrganizationDM: GenericsDM {
    let TABLENAME = "ongs"
    
    /// This func saves or updates a Organization
    func save(ong: Organization) {
        let ongId = Base64Converter.encodeStringAsBase64(ong.email)
        db.collection(TABLENAME).document(ongId).setData(ong.representation)
    }
    
    func listAll(completion: @escaping ([Organization]?, Error?) ->()) {
        db.collection(TABLENAME).getDocuments { (snapshot, err) in
            self.handleDocuments(snapshot, err, completion: completion)
        }
    }
    /// Optimized func to find an organization by email
    func find(ByEmail email:String, completion: @escaping (Organization?,Error?) -> Void) {
        let ongId = Base64Converter.encodeStringAsBase64(email)
        self.find(ById: ongId, completion: completion)
    }
    
    /// Optimized func to find an organization by id
    func find(ById id:String, completion: @escaping (Organization?,Error?) -> Void) {
        db.collection(TABLENAME).document(id).getDocument { (snapshot, err) in
            self.handleSingleDocument(snapshot, err, completion: completion)
        }
    }
    
    /// func that filters the jobs by field equal to value
    /// - Parameters:
    ///   - field: The field that needs to be equal to the value - its one of the JobFields (enum)
    ///   - value: A string that represents the value
    ///   - completion: Function to be executed when the search on firebase was finished
    func find(inField field: OrganizationFields, withValueEqual value:String, completion: @escaping ([Organization]?,Error?) ->()) {
        db.collection(TABLENAME).whereField(field.rawValue, isEqualTo: value).getDocuments() { (snapshot, err) in
            self.handleDocuments(snapshot, err, completion: completion)
       }
    }
    
    /// func hat filters jobs by field with a comparison that matches with the value
    /// - Parameters:
    ///   - field: The field that needs to match with the value using the comparison chosen
    ///   - comparison: comparison method to be used (e.g: equal, lessThan, greaterThan...)
    ///   - value: value that needs to be in field considering the comparison method
    ///   - completion: Function to be executed when the search on firebase was finished
    func find(inField field: OrganizationFields, comparison: ComparisonKind, withValue value:Any, completion: @escaping ([Organization]?,Error?) ->()){
        
        switch comparison {
        case .equal:
            db.collection(TABLENAME).whereField(field.rawValue, isEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            break
        case .lessThan:
            db.collection(TABLENAME).whereField(field.rawValue, isLessThan: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            break
        case .lessThanOrEqual:
            db.collection(TABLENAME).whereField(field.rawValue, isLessThanOrEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            break
        case .greaterThan:
            db.collection(TABLENAME).whereField(field.rawValue, isGreaterThan: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            break
        case .greaterThanOrEqual:
            db.collection(TABLENAME).whereField(field.rawValue, isGreaterThanOrEqualTo: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            break
        case .arrayContains:
            db.collection(TABLENAME).whereField(field.rawValue, arrayContains: value).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            break
        case .inArray:
            guard let array = value as? Array<Any> else {fatalError("Not an array")}
            db.collection(TABLENAME).whereField(field.rawValue, in: array).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        }
    }
}

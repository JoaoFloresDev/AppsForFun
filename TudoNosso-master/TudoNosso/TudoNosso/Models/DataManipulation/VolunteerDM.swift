//
//  VolunteerDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 18/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation


class VolunteerDM: GenericsDM {
    let TABLENAME  = "volunteers"
    
    func save(volunteer: Volunteer){
        let volunteerID = Base64Converter.encodeStringAsBase64(volunteer.email)
        db.collection(TABLENAME).document(volunteerID).setData(volunteer.representation)
    }
    
    func delete(ById id:String){
        db.collection(TABLENAME).document(id).delete()
    }
    
    func listAll(completion:@escaping ([Volunteer]?,Error?) -> ()){
        db.collection(TABLENAME).getDocuments { (snapshot, err) in
            self.handleDocuments(snapshot, err, completion: completion)
        }
    }
    
    func find(ById id:String, completion:@escaping (Volunteer?,Error?) -> ()){
        db.collection(TABLENAME).document(id).getDocument { (snapshot, err) in
            self.handleSingleDocument(snapshot, err, completion: completion)
        }
    }
    
    func find(ByEmail email: String, completion:@escaping (Volunteer?,Error?) -> ()){
        let volunteerID = Base64Converter.encodeStringAsBase64(email)
        self.find(ById: volunteerID, completion: completion)
    }
    
    func find(inField field: VolunteerFields, withValueEqual value:String, completion: @escaping ([Volunteer]?,Error?) ->()) {
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
    func find(inField field: VolunteerFields, comparison: ComparisonKind, withValue value:Any, completion: @escaping ([Volunteer]?,Error?) ->()){
        
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
            db.collection(TABLENAME).whereField(field.rawValue, in: array ).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
        }
    }
}

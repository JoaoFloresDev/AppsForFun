//
//  OportunityDM.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 07/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import FirebaseFirestore

class JobDM: GenericsDM {
    let TABLENAME = "oportunities"

    
    /// This func saves or updates a job
    func save(job: Job){
        //update an existing item
        if let jobID = job.id{
            db.collection(TABLENAME).document(jobID).setData(job.representation, merge: true) { (error) in
                if error != nil {
                    print("Error updating a job: \(error?.localizedDescription)")
                }
            }
        }else {//save new
            let channel = Channel(name: job.title, between: [job.organizationID], betweenKinds: ["ong"])
            let channelDM = ChannelDM()
            
            channelDM.save(channel: channel) { (channel) in
                let doc = self.db.collection(self.TABLENAME).document()
                job.id = doc.documentID
                
                guard let channelID = channel.id else { return }
                job.channelID = channelID
                
                doc.setData(job.representation)
            }
        }
    }
    
    func delete(ById id:String){
        db.collection(TABLENAME).document(id).delete { (error) in
            if error != nil {
                print("Error deleting a job: \(error?.localizedDescription)")
            }
        }
    }
    
    func listAll(completion: @escaping ([Job]?, Error?) ->()){
        db.collection(TABLENAME).getDocuments { (snapshot, err) in
            self.handleDocuments(snapshot, err, completion: completion)
        }
    }
    
    /// Optimized func to find job by id
    func find(ById id:String, completion: @escaping (Job?, Error?) -> Void) {
        db.collection(TABLENAME).document(id).getDocument { (snapshot, err) in
            self.handleSingleDocument(snapshot, err, completion: completion)
        }
    }
    
    /// func that filters the jobs by field equal to value
    /// - Parameters:
    ///   - field: The field that needs to be equal to the value - its one of the JobFields (enum)
    ///   - value: A string that represents the value
    ///   - completion: Function to be executed when the search on firebase was finished
    func find(inField field: JobFields, withValueEqual value:Any, completion: @escaping ([Job]?,Error?) ->()) {
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
    func find(inField field: JobFields, comparison: ComparisonKind, withValue value:Any, completion: @escaping ([Job]?,Error?) ->()){
        
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
            db.collection(TABLENAME).whereField(field.rawValue, in: [value]).getDocuments { (snapshot, error) in
                self.handleDocuments(snapshot, error, completion: completion)
            }
            
        }
    }
}

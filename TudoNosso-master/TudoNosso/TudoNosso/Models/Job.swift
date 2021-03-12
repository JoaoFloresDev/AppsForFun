//
//  Oportunity.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 06/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore.FIRGeoPoint


class Job {
    var id: String?
    var title: String
    var desc: String?
    var categories: [CategoryEnum] = []
    var vacancyType: String
    var vacancyNumber: Int
    var organizationID: String
    var localization: CLLocationCoordinate2D
    var status:Bool
    var engagedOnes:[String]? = []
    var channelID: String
    var address: String?
    
    var engagedOnesSlashVacancyNumber: String {
        let engagedCount = self.engagedOnes?.count ?? 0
        
        return String(format: "%02d envolvido(s) / %02d vaga(s)", engagedCount,vacancyNumber)
    }
    
    var firstCategoryAndCount:String{
        if categories.count > 0 {
            let localizedCategory = NSLocalizedString(categories[0].rawValue, comment: "")
            if categories.count > 1{
                return String(format: "\(localizedCategory) e +%02d",(categories.count-1))
            }
            return localizedCategory
        } else {
            return ""
        }
    }
    
    
    /// initialiazer with all not optional parameters of the class
    init( title: String, category: [CategoryEnum], vacancyType: String, vacancyNumber: Int, organizationID: String, localization: CLLocationCoordinate2D,status:Bool, channelID:String) {
        self.title = title
        self.categories = category
        self.vacancyType = vacancyType
        self.vacancyNumber = vacancyNumber
        self.organizationID = organizationID
        self.localization = localization
        self.status = status
        self.channelID = channelID
    }
    
    /// initialiazer with all parameters of the class
    init(id: String, title: String, desc: String, category: [CategoryEnum], vacancyType: String, vacancyNumber: Int, organizationID: String, localization: CLLocationCoordinate2D, status: Bool, engagedOnes:[String], channelID:String) {
        self.id = id
        self.title = title
        self.desc = desc
        self.categories = category
        self.vacancyType = vacancyType
        self.vacancyNumber = vacancyNumber
        self.organizationID = organizationID
        self.localization = localization
        self.status = status
        self.engagedOnes = engagedOnes
        self.channelID = channelID
    }
    
    /// Optional initialiazer with a dictionary
    /// - Parameter snapshot: The dictionary 
    init?(snapshot: NSDictionary) {
        guard
            let id: String = Self.snapshotFieldReader(snapshot,.id),
            let title: String = Self.snapshotFieldReader(snapshot,.title),
            let category: [String] = Self.snapshotFieldReader(snapshot,.categories),
            let vacancyType: String = Self.snapshotFieldReader(snapshot,.vacancyType),
            let vacancyNumber: Int = Self.snapshotFieldReader(snapshot,.vacancyNumber),
            let organizationID: String = Self.snapshotFieldReader(snapshot,.organizationID),
            let location: GeoPoint = Self.snapshotFieldReader(snapshot,.localization),
            let status: Bool = Self.snapshotFieldReader(snapshot,.status),
            let channelID: String = Self.snapshotFieldReader(snapshot, .channelID)
            else {
                return nil
        }
        let categoriesEnum = category.compactMap { (categoryString) -> CategoryEnum? in
            if let element = CategoryEnum(rawValue: categoryString){
                return element
            }
            return nil
        }
        self.categories = categoriesEnum
        self.id = id
        self.title = title
        self.vacancyType = vacancyType
        self.vacancyNumber = vacancyNumber
        self.organizationID = organizationID
        self.localization = CLLocationCoordinate2D.fromGeoPoint(geoPoint: location)
        self.status = status
        self.channelID = channelID
        self.desc = Self.snapshotFieldReader(snapshot,.description)
        self.engagedOnes = Self.snapshotFieldReader(snapshot,.engagedOnes)
        self.address = Self.snapshotFieldReader(snapshot,.address)
        
    }
}

extension Job: DatabaseRepresentation {
    
    
    var representation: [String : Any] {
        let categoriesString = categories.compactMap { (enumValue) -> String? in
            return enumValue.rawValue
        }
        
        
        var rep: [JobFields : Any] = [
            .id: id!,
            .title: title,
            .categories: categoriesString,
            .vacancyType: vacancyType,
            .vacancyNumber: vacancyNumber,
            .organizationID: organizationID,
            .localization: localization.toGeoPoint(),
            .status: status,
            .channelID: channelID,
            .address: address
        ]
        
        if let desc = self.desc{
            rep[.description] = desc
        }
        if let engagedOnes = self.engagedOnes{
            rep[.engagedOnes] = engagedOnes
        }
        return Dictionary(uniqueKeysWithValues: rep.map({ (key, value) in
            (key.rawValue, value)
        }))
    }
    
   
}

extension Job: DictionaryInterpreter {
    typealias fieldEnum = JobFields
    
    static func interpret(data: NSDictionary) -> Self? {
        return Job(snapshot: data) as? Self
    }
    
    static func snapshotFieldReader<T>(_ snapshot: NSDictionary, _ field:JobFields) -> T? {
           return snapshot[field.rawValue] as? T
    }
    
}

enum JobFields: String, Hashable  {
    case id
    case title
    case description = "desc"
    case categories = "category"
    case vacancyType
    case vacancyNumber
    case organizationID
    case localization
    case status
    case engagedOnes
    case channelID
    case address
}

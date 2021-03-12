//
//  Plant.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 20/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import Foundation
import UIKit

class Plant: LivingBeing {
    //MARK: Properties
    var type: PlantType
    var biome: String
    
    //MARK: Constructor
    init(_ name: String, _ scientificName: String, _ locationOnCampus: String, _ coordinate: (latitude: Double, longitude: Double), areaRadius: CGFloat, _ curiosity: String, _ photos: [UIImage?], _ type: PlantType, _ biome: String) {
        self.type = type
        self.biome = biome
        
        let beingClass: LivingBeingClass = {
            switch type {
            case .angiospermas:
                return LivingBeingClass.angiospermas
            case .gimnospermas:
                return LivingBeingClass.gimnospermas
            case .briofita:
                return LivingBeingClass.briofita
            case .pteridofitas:
                return LivingBeingClass.pteridofitas
            }
        }()
        super.init(name: name, scientificName: scientificName, beingClass: beingClass, locationOnCampus: locationOnCampus, coordinate: coordinate, areaRadius: areaRadius, habitatOrBiome: biome, curiosity: curiosity, photos: photos)
    }
    
    //MARK: Types
    struct PropertyKeyPlant {
        static let name = "name"
        static let scientificName = "scientific name"
        static let locationOnCampus = "location on campus"
        static let curiosity = "curiosity"
        static let photos = "photos"
        static let type = "type"
        static let biome = "biome"
    }
    
    //MARK: NSCoding Protocol
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(super.name, forKey: PropertyKeyPlant.name)
        aCoder.encode(super.scientificName, forKey: PropertyKeyPlant.scientificName)
        aCoder.encode(super.locationOnCampus, forKey: PropertyKeyPlant.locationOnCampus)
        aCoder.encode(super.curiosity, forKey: PropertyKeyPlant.curiosity)
        aCoder.encode(super.photos, forKey: PropertyKeyPlant.photos)
        aCoder.encode(type.rawValue, forKey: PropertyKeyPlant.type)
        aCoder.encode(biome, forKey: PropertyKeyPlant.biome)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKeyPlant.name) as? String else { return nil}
        guard let scientificName = aDecoder.decodeObject(forKey: PropertyKeyPlant.scientificName) as? String else { return nil}
        guard let locationOnCampus = aDecoder.decodeObject(forKey: PropertyKeyPlant.locationOnCampus) as? String else { return nil}
        guard let curiosity = aDecoder.decodeObject(forKey: PropertyKeyPlant.curiosity) as? String else { return nil}
        guard let photos = aDecoder.decodeObject(forKey: PropertyKeyPlant.photos) as? [UIImage] else { return nil }
        guard let type = PlantType(rawValue: aDecoder.decodeObject(forKey: PropertyKeyPlant.type) as! String) else { return nil}
        guard let biome = aDecoder.decodeObject(forKey: PropertyKeyPlant.biome) as? String else { return nil}

        self.init(name, scientificName, locationOnCampus, (0.0, 0.0), areaRadius: 0.0, curiosity, photos, type, biome)
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("plant")
}

enum PlantType: String {
    case briofita = "Briophytes"
    case pteridofitas = "Pteridophytes"
    case angiospermas = "Angiosperms"
    case gimnospermas = "Gimnosperms"
    
    func returnLocalizedValue() -> String {
        var returnValue: String
        
        switch self {
        case .briofita:
            returnValue = NSLocalizedString("Briophytes", comment: "")
            break
        case .pteridofitas:
            returnValue = NSLocalizedString("Pteridophytes", comment: "")
            break
        case .angiospermas:
            returnValue = NSLocalizedString("Angiosperms", comment: "")
            break
        case .gimnospermas:
            returnValue = NSLocalizedString("Gimnosperms", comment: "")
            break
    }
    return returnValue
    }
}

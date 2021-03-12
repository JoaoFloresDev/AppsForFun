//
//  Animal.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 20/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import Foundation
import UIKit

class Animal: LivingBeing {
    //MARK: Properties
    var type: AnimalType
    var habitat: String
    
    //MARK: Constructor
    init(_ name: String = "",
         _ scientificName: String = "",
         _ locationOnCampus: String = "",
         _ coordinate: (latitude: Double, longitude: Double) = (0.0, 0.0),
         areaRadius: CGFloat = 0.0,
         _ curiosity: String = "",
         _ photos: [UIImage?] = [],
         _ type: AnimalType = .amphibian,
         _ habitat: String = "") {
        
        self.type = type
        self.habitat = habitat
        
        let beingClass: LivingBeingClass = {
            switch type {
            case .amphibian:
                return LivingBeingClass.amphibian
            case .bird:
                return LivingBeingClass.bird
            case .mammal:
                return LivingBeingClass.mammmal
            case .reptile:
                return LivingBeingClass.reptile
            case .fish:
                return LivingBeingClass.fish
            case .insect:
                return LivingBeingClass.insect
            }
        }()
        
        super.init(name: name, scientificName: scientificName, beingClass: beingClass, locationOnCampus: locationOnCampus, coordinate: coordinate, areaRadius: areaRadius, habitatOrBiome: habitat, curiosity: curiosity, photos: photos)
    }
    
    //MARK: Types
    struct PropertyKeyAnimal {
        static let name = "name"
        static let scientificName = "scientific name"
        static let locationOnCampus = "location on campus"
        static let curiosity = "curiosity"
        static let photos = "photos"
        static let type = "type"
        static let habitat = "habitat"
    }
    
    //MARK: NSCoding Protocol
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(super.name, forKey: PropertyKeyAnimal.name)
        aCoder.encode(super.scientificName, forKey: PropertyKeyAnimal.scientificName)
        aCoder.encode(super.locationOnCampus, forKey: PropertyKeyAnimal.locationOnCampus)
        aCoder.encode(super.curiosity, forKey: PropertyKeyAnimal.curiosity)
        aCoder.encode(super.photos, forKey: PropertyKeyAnimal.photos)
        aCoder.encode(type.rawValue, forKey: PropertyKeyAnimal.type)
        aCoder.encode(habitat, forKey: PropertyKeyAnimal.habitat)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKeyAnimal.name) as? String else { return nil}
        guard let scientificName = aDecoder.decodeObject(forKey: PropertyKeyAnimal.scientificName) as? String else { return nil}
        guard let locationOnCampus = aDecoder.decodeObject(forKey: PropertyKeyAnimal.locationOnCampus) as? String else { return nil}
        guard let curiosity = aDecoder.decodeObject(forKey: PropertyKeyAnimal.curiosity) as? String else { return nil}
        guard let photos = aDecoder.decodeObject(forKey: PropertyKeyAnimal.photos) as? [UIImage] else { return nil }
        guard let type =  AnimalType(rawValue: aDecoder.decodeObject(forKey: PropertyKeyAnimal.type) as! String) else { return nil }
        guard let habitat = aDecoder.decodeObject(forKey: PropertyKeyAnimal.habitat) as? String else { return nil}
        let coordinate = (0.0, 0.0)
        self.init(name, scientificName, locationOnCampus, coordinate, curiosity, photos, type, habitat)
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("animal")
}

enum AnimalType: String, Codable {
    case amphibian = "Amphibians"
    case bird = "Birds"
    case mammal = "Mammals"
    case reptile = "Reptiles"
    case insect = "Insects"
    case fish = "Fish"
    
    func returnLocalizedValue() -> String {
        var returnValue: String
        
        switch self {
        case .amphibian:
            returnValue = NSLocalizedString("Amphibians", comment: "")
            break
        case .bird:
            returnValue = NSLocalizedString("Birds", comment: "")
            break
        case .mammal:
            returnValue = NSLocalizedString("Mammals", comment: "")
            break
        case .reptile:
            returnValue = NSLocalizedString("Reptiles", comment: "")
            break
        case .insect:
            returnValue = NSLocalizedString("Insects", comment: "")
            break
        case .fish:
            returnValue = NSLocalizedString("Fish", comment: "")
    }
    return returnValue
    }
}

//
//  LivingBeing.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 20/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import Foundation
import UIKit

class LivingBeing: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        
    }
    
    required init?(coder: NSCoder) {
        name = ""
        scientificName = ""
        beingClass = .amphibian
        locationOnCampus  = ""
        coordinate = (0.0, 0.0)
        areaRadius = 0.0
        habitatOrBiome  = ""
        curiosity = ""
        photos = []
        super.init()
    }
    
    
    public enum LivingBeingClass: String {
        case amphibian
        case bird
        case mammmal
        case reptile
        case fish
        case insect
        case briophyte
        case pteridophytes
        case angiosperms
        case gimnosperms
    }

    var name: String
    var scientificName: String
    var beingClass: LivingBeingClass
    var locationOnCampus: String
    var coordinate: (latitude: Double, longitude: Double)
    var areaRadius: CGFloat
    var habitatOrBiome: String
    var curiosity: String
    var photos: [UIImage?] = [] //trocar por url futuramente e modificar encapsulamento
    
    init(name: String = "",
         scientificName: String = "",
         beingClass: LivingBeingClass,
         locationOnCampus: String  = "",
         coordinate: (latitude: Double, longitude: Double) = (0.0, 0.0),
         areaRadius: CGFloat = 0.0,
         habitatOrBiome: String  = "",
         curiosity: String  = "",
         photos: [UIImage?] = []) {
        
        self.name = name
        self.scientificName = scientificName
        self.beingClass = beingClass
        self.locationOnCampus = locationOnCampus
        self.coordinate = coordinate
        self.areaRadius = areaRadius
        self.habitatOrBiome = habitatOrBiome
        self.curiosity = curiosity
        self.photos = photos
    }
}

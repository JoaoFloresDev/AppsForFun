//
//  MVPData.swift
//  CampusSelvagem
//
//  Created by André Papoti de Oliveira on 28/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import UIKit

class MVPData {
    
    static let sharedInstance = MVPData()
    
    var data: [LivingBeing] = []
    private init(){
        var photos: [UIImage?] = []
        
        /// ### AVES
        photos.append(UIImage(named: "corujas1"))
        photos.append(UIImage(named: "corujas2"))
        data.append(LivingBeing(name: NSLocalizedString("Burrowing owl", comment: ""),
                                scientificName: "Athene cunicularia",
                                beingClass: .bird,
                                locationOnCampus: NSLocalizedString("FEAGRIS's parking lot", comment: ""),
                                coordinate: (latitude: -22.817016, longitude: -47.060604),
                                areaRadius: 70,
                                habitatOrBiome: NSLocalizedString("Brazilian restinga and cerrado", comment: ""),
                                curiosity: NSLocalizedString("Male individuals stay out of the nest with the task of watching, resting and observing. The presence of female individuals is more subtle, due to its permanence inside of the burrow. They feed off small rodents, reptiles, amphibians, birds (such as sparrows), scorpions, etc.", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        photos.append(UIImage(named: "peregrino00"))
        photos.append(UIImage(named: "peregrino01"))
        data.append(LivingBeing(name: NSLocalizedString("Peregrine falcon", comment: ""),
                                scientificName: "Falco peregrinus",
                                beingClass: .bird,
                                locationOnCampus: NSLocalizedString("It can be seen everyewhere on campus, though it's more frequently seen around the Performing Arts building", comment: ""),
                                coordinate: (latitude: -22.815381, longitude: -47.070758),
                                areaRadius: 90,
                                habitatOrBiome: NSLocalizedString("It can be seen in all continents, except Antartica", comment: ""),
                                curiosity: NSLocalizedString("Nowadays this bird is considered the fastest bird on earth, being able to achieve around 199 mph or more", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        photos.append(UIImage(named: "carcara00"))
        photos.append(UIImage(named: "carcara01"))
        data.append(LivingBeing(name: NSLocalizedString("Southern caracara", comment: ""),
                                scientificName: "Caracara plancus",
                                beingClass: .bird,
                                locationOnCampus: NSLocalizedString("It can be seen around all campus, most frequently around the buildings of the Institute of Arts and the Institute of linguistics", comment: ""),
                                coordinate: (latitude: -22.814893, longitude: -47.069642),
                                areaRadius: 150,
                                habitatOrBiome: NSLocalizedString("It inhabits the center and south regions of South America", comment: ""),
                                curiosity: NSLocalizedString("In order to communicate with other individuals in its territory or to comunnicate with its partner, it shouts a chant from which its name is originated from", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        photos.append(UIImage(named: "gralha00"))
        photos.append(UIImage(named: "gralha01"))
        data.append(LivingBeing(name: NSLocalizedString("Curl-crested jay", comment: ""),
                                scientificName: "Cyanocorax cristatellus",
                                beingClass: .bird,
                                locationOnCampus: NSLocalizedString("It can mostly be seen around the lake house" , comment: ""),
                                coordinate: (latitude: -22.812800, longitude: -47.069803),
                                areaRadius: 100,
                                habitatOrBiome: NSLocalizedString("Native to brazilian cerrado and caatinga", comment: ""),
                                curiosity: NSLocalizedString("Their flocks usually have a determined region and fly the same course everyday, turning predictable theirs visiting hour to certain spots in some cases.", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        // ### MAMIFEROS
        photos.append(UIImage(named: "cacheiro00"))
        photos.append(UIImage(named: "cacheiro01"))
        data.append(LivingBeing(name: NSLocalizedString("Hedgehog", comment: ""),
                                scientificName: "Coendou prehensilis",
                                beingClass: .mammmal,
                                locationOnCampus: NSLocalizedString("It can be spotted around all campus, though more frequently they appear next to the building of the dep. of Medical Sciences", comment: ""),
                                coordinate: (latitude: -22.830147, longitude: -47.062524),
                                areaRadius: 210,
                                habitatOrBiome: NSLocalizedString("They inhabit in Brazil, occuring from the state of Rio de Janeiro until Rio Grande do Sul, including Minas Gerais", comment: ""),
                                curiosity: NSLocalizedString("They only conceive one cub per litter", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        /// ### REPTEIS
        photos.append(UIImage(named: "teiu00"))
        data.append(LivingBeing(name: NSLocalizedString("Tegu lizard", comment: ""),
                                scientificName: "Salvator merianae",
                                beingClass: .reptile,
                                locationOnCampus: NSLocalizedString("They can be seen around all campus, but more frequently near the building of the Computer and Eletrical engineering dep.", comment: ""),
                                coordinate: (latitude: -22.821178, longitude: -47.065785),
                                areaRadius: 200,
                                habitatOrBiome: NSLocalizedString("They inhabit all of Brazil (except for the Amazon rainforest area) and places such as the north of Argentina and Uruguay", comment: ""),
                                curiosity: NSLocalizedString("They have the capacity to increase their metabolic rate in copulation season to rates similar to those of mammals and birds, generating heat and keeping their body temperature higher than of its environment.", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        /// ### INSETOS
        photos.append(UIImage(named: "gafanhoto"))
        data.append(LivingBeing(name: NSLocalizedString("European mantis", comment: ""),
                                scientificName: "Gryllus religiosa",
                                beingClass: .insect,
                                locationOnCampus: NSLocalizedString("It can be seen around all campus, but they more frequently appear next to the student council building.", comment: ""),
                                coordinate: (latitude: -22.817901, longitude: -47.071941),
                                areaRadius: 200,
                                habitatOrBiome: NSLocalizedString("They can be found in south Europe, Americas, Asia, Africa and Australia" , comment: ""),
                                curiosity: NSLocalizedString("Its courting and pairing can be separated in two stages: preliminar courting and copulation itself. Premilinar courting starts with the eye contact of those individuals and it ends at the start of the first physical contact. Copulation starts with the first physical contact and it ends with the deposit of the spermatofagus.", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        /// ### PLANTAE
        
        photos.append(UIImage(named: "flor1"))
        photos.append(UIImage(named: "flor2"))
        data.append(LivingBeing(name: NSLocalizedString("Cannon ball tree", comment: ""),
                                scientificName: "Couroupita guianensis",
                                beingClass: .angiosperms,
                                locationOnCampus: NSLocalizedString("Peace square", comment: ""),
                                coordinate: (latitude: -22.821975, longitude: -47.067189),
                                areaRadius: 30,
                                habitatOrBiome: NSLocalizedString("Brazil's atlantic forest area", comment: ""),
                                curiosity: NSLocalizedString("It can reach heights between 19 and 49 ft", comment: ""),
                                photos: photos))
        photos.removeAll()
        
        photos.append(UIImage(named: "paubrasil"))
        photos.append(UIImage(named: "paubrasil2"))
        data.append(LivingBeing(name: NSLocalizedString("Brazilwood", comment: ""),
                                scientificName: "Paubrasilia echinata",
                                beingClass: .angiosperms,
                                locationOnCampus:NSLocalizedString("Peace square", comment: ""),
                                coordinate: (latitude: -22.823231, longitude: -47.068058),
                                areaRadius: 30,
                                habitatOrBiome: NSLocalizedString("Atlantic florest", comment: ""),
                                curiosity: NSLocalizedString("It's considered a national symbol", comment: ""),
                                photos: photos))
        photos.removeAll()
    }
}

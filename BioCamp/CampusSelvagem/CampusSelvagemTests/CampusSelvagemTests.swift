//
//  CampusSelvagemTests.swift
//  CampusSelvagemTests
//
//  Created by Felipe Semissatto on 19/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import XCTest
@testable import CampusSelvagem

class CampusSelvagemTests: XCTestCase {

    //MARK: Properties - System Under Tests (SUTs)
    var sutLivingBeing: LivingBeing!
    var sutAnimal: Animal!
    var sutPlant: Plant!
    
    //MARK: Default Test Methods
    override func setUp() {
        super.setUp()
        
        sutLivingBeing = LivingBeing(beingClass: .ave)
        sutAnimal = Animal()
    }

    override func tearDown() {
        sutLivingBeing = nil
        sutAnimal = nil
        sutPlant = nil
        
        super.tearDown()
    }
    
    //MARK: Tests Models
    func testAppendPhotoLivingBeing() {
        sutLivingBeing.photos.append(UIImage(named: "peregrino00"))
        
        XCTAssertGreaterThan(sutLivingBeing.photos.count, 0, "Photo not stored.")
    }
    
    func testDecoderAnimal(){
        let path = NSTemporaryDirectory() as NSString
        let locToSave = path.appendingPathComponent("testAnimals")

        // creating object
        let photo1 = UIImage(named: "corujas1")
        let photo2 = UIImage(named: "corujas2")

        var photos: [UIImage] = []
        
        photos.append(photo1!)
        photos.append(photo2!)
                
        let animal = Animal("Coruja Buraqueira",
                            "Athene cunicularia",
                            "Estacionamento da FEAGRI",
                            (0.0, 0.0),
                            areaRadius: 0.0,
                            "Os machos permanecem fora do ninho com a função de vigiar, descansar e observar. A presença da fêmea é mais oculta, devido a sua permanência no interior da toca.",
                            photos,
                            .bird,
                            "Tem hábito diurno e noturno. Durante a manhã elas são inativas na maior parte do tempo ou tem comportamentos de vigília contra possíveis predadores.")

        // save animals
        NSKeyedArchiver.archiveRootObject([animal], toFile: locToSave)

        // load animals
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? [Animal]

        XCTAssertNotNil(data, "Animals not loaded.")
        XCTAssertEqual(data!.count, 1, "Animals is empty.")
        XCTAssertEqual(data!.first?.name, "Coruja Buraqueira", "Animal created incorrectly (name).")
        XCTAssertEqual(data!.first?.scientificName, "Athene cunicularia", "Animal created incorrectly (scientificName).")
        XCTAssertEqual(data!.first?.locationOnCampus, "Estacionamento da FEAGRI", "Animal created incorrectly (locationOnCampus).")
        XCTAssertEqual(data!.first?.coordinate.latitude, 0.0, "Animal created incorrectly (latitude).")
        XCTAssertEqual(data!.first?.coordinate.longitude, 0.0, "Animal created incorrectly (latitude).")
        XCTAssertEqual(data!.first?.areaRadius, 0.0, "Animal created incorrectly (areaRadius).")
        XCTAssertEqual(data!.first?.curiosity, "Os machos permanecem fora do ninho com a função de vigiar, descansar e observar. A presença da fêmea é mais oculta, devido a sua permanência no interior da toca.", "Animal created incorrectly (curiosity).")
        XCTAssertEqual(data!.first?.photos, photos, "Animal created incorrectly (photos).")
        XCTAssertEqual(data!.first?.type, .bird, "Animal created incorrectly (type).")
        XCTAssertEqual(data!.first?.habitat, "Tem hábito diurno e noturno. Durante a manhã elas são inativas na maior parte do tempo ou tem comportamentos de vigília contra possíveis predadores.", "Animal created incorrectly (habitat).")
    }
    
    func testDecoderPlant(){
        let path = NSTemporaryDirectory() as NSString
        let locToSave = path.appendingPathComponent("testPlants")

        // creating object
        let photo1 = UIImage(named: "flor1")
        let photo2 = UIImage(named: "flor2")
        
        var photos: [UIImage] = []
        
        photos.append(photo1!)
        photos.append(photo2!)
        
        let plant = Plant("Abricó-de-macaco",
                            "Couroupita guianensis",
                            "Praça da Paz",
                            (0.0, 0.0),
                            areaRadius: 0.0,
                            "Podem ter altura média entre 8 e 15 metros",
                            photos,
                            .angiospermas,
                            "Mata Atlântica")
        // save plants
        NSKeyedArchiver.archiveRootObject([plant], toFile: locToSave)

        // load plants
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave) as? [Plant]

        XCTAssertNotNil(data, "Plants not loaded.")
        XCTAssertEqual(data!.count, 1, "Plants is empty.")
        XCTAssertEqual(data!.first?.name, "Abricó-de-macaco", "Plant created incorrectly (name).")
        XCTAssertEqual(data!.first?.scientificName, "Couroupita guianensis", "Plant created incorrectly (scientificName).")
        XCTAssertEqual(data!.first?.locationOnCampus, "Praça da Paz", "Plant created incorrectly (locationOnCampus).")
        XCTAssertEqual(data!.first?.coordinate.latitude, 0.0, "Plant created incorrectly (latitude).")
        XCTAssertEqual(data!.first?.coordinate.longitude, 0.0, "Plant created incorrectly (latitude).")
        XCTAssertEqual(data!.first?.areaRadius, 0.0, "Plant created incorrectly (areaRadius).")
        XCTAssertEqual(data!.first?.curiosity, "Podem ter altura média entre 8 e 15 metros", "Plant created incorrectly (curiosity).")
        XCTAssertEqual(data!.first?.photos, photos, "Plant created incorrectly (photos).")
        XCTAssertEqual(data!.first?.type, .angiospermas, "Plant created incorrectly (type).")
        XCTAssertEqual(data!.first?.biome, "Mata Atlântica", "Plant created incorrectly (habitat).")
    }

}

//
//  LivingBeingViewController.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 21/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import UIKit
import CenteredCollectionView


class LivingBeingViewController: UIViewController {
    //MARK: Properties
    var livingBeing: LivingBeing?
    var pages: [UIImageView] = []
    
    //MARK: Outlets
    @IBOutlet weak var centeredCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!

    // The width of each cell with respect to the screen.
    // Can be a constant or a percentage.
    let cellPercentWidth: CGFloat = 0.9
    
    // A reference to the `CenteredCollectionViewFlowLayout`.
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Centered Collection View pod Setup
        
        centeredCollectionViewFlowLayout = (centeredCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout)
    
        centeredCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        centeredCollectionView.delegate = self
        centeredCollectionView.dataSource = self
        
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth
        )
        
        centeredCollectionViewFlowLayout.minimumLineSpacing = 5
        
        centeredCollectionView.showsVerticalScrollIndicator = false
        centeredCollectionView.showsHorizontalScrollIndicator = false 
        
        // End of the setup
        
        textView.allowsEditingTextAttributes = false
        
        if let animal = self.livingBeing as? Animal {
            showAnimalDetails(animal.name,
                              animal.scientificName,
                              animal.locationOnCampus,
                              animal.curiosity,
                              animal.type,
                              animal.habitat)
            
        
        } else if let plant = self.livingBeing as? Plant {
            showPlantDetails(plant.name,
                              plant.scientificName,
                              plant.locationOnCampus,
                              plant.curiosity,
                              plant.type,
                              plant.biome)
            
            
        }
    }
    
    //MARK: Private Methods
    public func showAnimalDetails(_ name: String, _ scientificName: String, _ locationOnCampus: String, _ curiosity: String, _ type: AnimalType, _ habitat: String){
        let text = "<font face = \"sans-serif\" size=\"14\"> \(name) </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> <i>\(scientificName)</i> </font> <hr>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Tipo</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(type.rawValue) </font> <br><br>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Habitat</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(habitat) </font> <br><br>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Localização no campus</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(locationOnCampus) </font> <br><br>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Curiosidade</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(curiosity) </font>"
        
        textView.attributedText = text.htmlToAttributedString
    }
    
    public func showPlantDetails(_ name: String, _ scientificName: String, _ locationOnCampus: String, _ curiosity: String, _ type: PlantType, _ biome: String){
        let text = "<font face = \"sans-serif\" size=\"14\"> \(name) </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> <i>\(scientificName)</i> </font> <hr>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Tipo</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(type.rawValue) </font> <br><br>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Bioma</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(biome) </font> <br><br>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Localização no campus</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(locationOnCampus) </font> <br><br>" +
                    "<font face = \"sans-serif\" size=\"6\"> <b>Curiosidade</b> </font> <br>" +
                    "<font face = \"sans-serif\" size=\"5\"> \(curiosity) </font>"
        
        textView.attributedText = text.htmlToAttributedString
    }
}

//MARK: Extension
public extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension LivingBeingViewController : UICollectionViewDelegate {
    // Insert CollectioView delegate methods if necessary here
}

extension LivingBeingViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var returnValue: Int = 0
        
        
        if let animal = self.livingBeing as? Animal {
            returnValue = animal.photos.count
        } else if let plant = self.livingBeing as? Plant {
            returnValue = plant.photos.count
        }
        
        return returnValue
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let myCell = self.centeredCollectionView.dequeueReusableCell(withReuseIdentifier: "centeredCollectionCell", for: indexPath) as? CenteredCollectionViewCell {
            
            if let animal = self.livingBeing as? Animal {
                myCell.cellImageView.image = animal.photos[indexPath.row]
            } else if let plant = self.livingBeing as? Plant {
                myCell.cellImageView.image = plant.photos[indexPath.row]
            }
            
            return myCell
        }
        
        return UICollectionViewCell()
        
    }

}


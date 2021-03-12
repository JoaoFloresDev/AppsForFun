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
    // - MARK: Properties
    var livingBeing: LivingBeing?
    var pages: [UIImageView] = []
    // The width of each cell with respect to the screen.
    // Can be a constant or a percentage.
    let cellPercentWidth: CGFloat = 0.9
    // A reference to the `CenteredCollectionViewFlowLayout`.
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    // var accessibilityElements = [UIAccessibilityElement]()
    
    // MARK: - Outlets
    @IBOutlet weak var picturesView: UIView!
    @IBOutlet weak var centeredCollectionView: UICollectionView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameContent: UILabel!
    @IBOutlet weak var scientificNameView: UIView!
    @IBOutlet weak var lblScientificName: UILabel!
    @IBOutlet weak var lblScientificNameContent: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTypeContent: UILabel!
    @IBOutlet weak var habitatBiomeView: UIView!
    @IBOutlet weak var lblHabitatBiome: UILabel!
    @IBOutlet weak var lblHabitatBiomeContent: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLocationContent: UILabel!
    @IBOutlet weak var curiosityView: UIView!
    @IBOutlet weak var lblCuriosity: UILabel!
    @IBOutlet weak var lblCuriosityContent: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Applying bold and italic fonts
//        lblScientificNameContent.font = UIFont.italicSystemFont(withTextStyle: UIFont.TextStyle.subheadline)
        
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
        
        // Populate labels
        self.lblNameContent.text = self.livingBeing?.name
        self.lblScientificNameContent.text = self.livingBeing?.scientificName
        if let animal = self.livingBeing as? Animal {
            self.lblTypeContent.text = animal.type.returnLocalizedValue()
            self.lblHabitatBiomeContent.text = animal.habitat
        }
        else if let plant = self.livingBeing as? Plant {
            self.lblTypeContent.text = plant.type.returnLocalizedValue()
            self.lblHabitatBiomeContent.text = plant.biome
        }
        else {
            print("Error: Couldnt cast living being")
        }
        self.lblLocationContent.text = self.livingBeing?.locationOnCampus
        self.lblCuriosityContent.text = self.livingBeing?.curiosity
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            self.stackView.axis = .horizontal
        } else {
            self.stackView.axis = .vertical
            
        }
        
        // Localization setup
        self.lblName.text = NSLocalizedString("Name", comment: "")
        self.lblScientificName.text = NSLocalizedString("Scientific name", comment: "")
        self.lblType.text = NSLocalizedString("Type", comment: "")
        self.lblHabitatBiome.text = NSLocalizedString("Habitat/Biome", comment: "")
        self.lblLocation.text = NSLocalizedString("Location", comment: "")
        self.lblCuriosity.text = NSLocalizedString("Curiosity", comment: "")
        
        setupAccessibility()
    }
    
    func setupAccessibility() {
        
        if let name = lblName.text, let nameContent = lblNameContent.text,
            let scientificName = lblScientificName.text, let scientificNameContent = lblCuriosityContent,
            let type = lblType.text, let typeContent = lblTypeContent.text,
            let habitatBiome = lblHabitatBiome.text, let habitatBiomeContent = lblHabitatBiomeContent,
            let location = lblLocation, let locationContent = lblLocationContent,
            let curiosity = lblCuriosity, let curiosityContent = lblCuriosityContent {
            picturesView.isAccessibilityElement = true
            picturesView.accessibilityLabel = NSLocalizedString("Pictures of", comment: "") + "\(name)"
            
            nameView.isAccessibilityElement = true
            nameView.accessibilityLabel = "\(name), \(nameContent)"
            
            scientificNameView.isAccessibilityElement = true
            scientificNameView.accessibilityLabel = "\(scientificName), \(scientificNameContent)"
            
            typeView.isAccessibilityElement = true
            typeView.accessibilityLabel = "\(type), \(typeContent)"
            
            habitatBiomeView.isAccessibilityElement = true
            habitatBiomeView.accessibilityLabel = "\(habitatBiome), \(habitatBiomeContent)"
            
            locationView.isAccessibilityElement = true
            locationView.accessibilityLabel = "\(location), \(locationContent)"
            
            curiosityView.isAccessibilityElement = true
            curiosityView.accessibilityLabel = "\(curiosity), \(curiosityContent)"
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("pse")
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.stackView.axis = .horizontal
            } else {
                self.stackView.axis = .vertical
                
            }
        })
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
            
            myCell.cellImageView.contentMode = .scaleAspectFit
            
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


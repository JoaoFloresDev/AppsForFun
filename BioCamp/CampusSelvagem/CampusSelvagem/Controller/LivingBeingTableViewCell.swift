//
//  LivingBeingTableViewCell.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 21/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import UIKit

class LivingBeingTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.cornerRadius = photoImageView.bounds.width/2
        nameLabel.adjustsFontForContentSizeCategory = true
        scientificNameLabel.adjustsFontForContentSizeCategory = true
        layoutIfNeeded()
//        scientificNameLabel.font = UIFont.italicSystemFont(withTextStyle: UIFont.TextStyle.subheadline)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellVoiceOver(_ livingBeing: LivingBeing){
        // 1. Make Voice over ignore the UITextView
        self.nameLabel.isAccessibilityElement = false
        self.scientificNameLabel.isAccessibilityElement = false

        // 2. Make Voice Over highlight this UITableViewCell as an element
        isAccessibilityElement = true

        // 3. Improve the read back by customizing the label. This should sound much nicer.
        if let animal = livingBeing as? Animal {
            accessibilityLabel = "Nome do animal: \(animal.name). Nome científico: \(animal.scientificName)."
        } else if let plant = livingBeing as? Plant {
            accessibilityLabel = "Nome da planta: \(plant.name). Nome científico: \(plant.scientificName)."
        }
        accessibilityHint = "Duplo toque para mais informações"
    }
}

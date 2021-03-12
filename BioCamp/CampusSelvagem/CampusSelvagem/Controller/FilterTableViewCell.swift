//
//  TableViewCell.swift
//  CampusSelvagem
//
//  Created by João Pedro de Amorim on 21/08/19.
//  Copyright © 2019 Felipe Semissatto. All rights reserved.
//

import UIKit


protocol FilterDelegate: class {
    func filter(selectedCell: (row: Int, page: Int), setTo value: Bool)
}


class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var filterCellLabel: UILabel!
    @IBOutlet weak var filterCellSwitch: UISwitch!
    
    weak var delegate: FilterDelegate?
    
    var cellCoordinates: (row: Int, page: Int)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switchChanges(_ target: UISwitch) {
        if let coordinates = self.cellCoordinates {
            delegate?.filter(selectedCell: coordinates, setTo: target.isOn)
        }
    }

}

//
//  VideoCell.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit


protocol CellCasesOrganizationsDelegate: NSObjectProtocol {
    func causeSelected(_ cell: CellCasesOrganizations)
}

class CellCasesOrganizations : UICollectionViewCell {
    
    //MARK: - OUTLETS
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - PROPERTIES
    weak var delegate: CellCasesOrganizationsDelegate!
    var email = ""
    
    //MARK: - ACTIONS
    @IBAction func causeSelected(_ sender: Any) {
        
        if let delegate = self.delegate {
            delegate.causeSelected(self)
        }
    }
    
    @IBAction func organizationSelected(_ sender: Any) {
        
        if let delegate = self.delegate {
            delegate.causeSelected(self)
        }
    }
}

//
//  AreaCollectionCell.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 14/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class AreaCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    static let reuseIdentifer = String(describing: AreaCollectionCell.self)
    
    var text : String = "" {
        didSet{
            self.label.text = text
            self.frame.size.width = self.label.intrinsicContentSize.width + 16
        }
    }
    
    static var nib: UINib {
           let nibName = String(describing: AreaCollectionCell.self)
           return UINib(nibName: nibName, bundle: nil)
       }
}


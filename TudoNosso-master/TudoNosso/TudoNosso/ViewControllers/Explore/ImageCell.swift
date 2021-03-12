//
//  VideoCell.swift
//  TwoDirectionalScroller
//
//  Created by Robert Chen on 7/11/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class CollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func causeSelected(_ sender: Any) {
        print("tag image:", imageView.tag)
    }
    
    @IBAction func organizationSelected(_ sender: Any) {
        print("tag image:", imageView.tag)
    }
}

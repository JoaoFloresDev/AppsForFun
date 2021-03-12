//
//  CustomSegmentedControl.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 07/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class CustomSegmentedControl : UISegmentedControl {
    let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 13)]
    let normalTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appBlack, NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 13)]

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        self.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        self.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
    }
}

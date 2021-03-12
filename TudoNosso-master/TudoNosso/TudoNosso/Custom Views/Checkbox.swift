//
//  Checkbox.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 28/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class Checkbox: UIButton {

    let checkedImage = UIImage(named: "selected-checkbox")! as UIImage
    let uncheckedImage = UIImage(named: "checkbox")! as UIImage

    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

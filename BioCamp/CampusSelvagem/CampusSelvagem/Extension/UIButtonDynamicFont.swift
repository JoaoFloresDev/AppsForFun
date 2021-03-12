//
//  UIButtonDynamicFont.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 05/02/20.
//  Copyright © 2020 Felipe Semissatto. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    var dynamicFont: UIFont {
        set {
            self.titleLabel?.dynamicFont = newValue
            self.titleLabel?.textAlignment = .center
            self.titleLabel?.lineBreakMode = .byWordWrapping
        }
        
        get {
            return self.titleLabel?.font ?? UIFont()
        }
    }
}

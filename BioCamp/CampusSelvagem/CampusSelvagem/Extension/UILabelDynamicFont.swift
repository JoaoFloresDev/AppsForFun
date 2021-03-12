//
//  UILabelDynamicFont.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 05/02/20.
//  Copyright © 2020 Felipe Semissatto. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    var dynamicFont: UIFont {
        set {
            self.numberOfLines = 0
            
            if #available(iOS 10.0, *){
                self.adjustsFontForContentSizeCategory = true
            }
            
            let fontMetrics = UIFontMetrics(forTextStyle: .body)
            self.font = fontMetrics.scaledFont(for: newValue)
        }
        
        get {
            return self.font
        }
    }
}

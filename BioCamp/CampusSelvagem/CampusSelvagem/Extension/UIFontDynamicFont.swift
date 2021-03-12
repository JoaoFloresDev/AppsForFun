//
//  UIFontDynamicFont.swift
//  CampusSelvagem
//
//  Created by Felipe Semissatto on 05/02/20.
//  Copyright © 2020 Felipe Semissatto. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    
    static func boldSystemFont(withTextStyle textStyle: UIFont.TextStyle)-> UIFont {
        
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        let font = UIFont.boldSystemFont(ofSize: descriptor.pointSize)
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    static func italicSystemFont(withTextStyle textStyle: UIFont.TextStyle)-> UIFont {
        
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        
        let font = UIFont.italicSystemFont(ofSize: descriptor.pointSize)
        
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
}

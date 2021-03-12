//
//  UIView+Extensions.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 06/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

 extension UIView {

     func rounded(corner: Double) {
         layer.cornerRadius = CGFloat(corner)
         layer.masksToBounds = true
     }

     func circle() {
         let size = Double(min(frame.width, frame.height))
         rounded(corner: size/2)
     }
     
     func dropShadow (radius: CGFloat, opacity: Float, color: UIColor = .black) {
         layer.masksToBounds = false
         layer.shadowColor = color.cgColor
         layer.shadowOffset = CGSize(width: 1, height: 1)
         layer.shadowOpacity = opacity
         layer.cornerRadius = radius
         layer.shouldRasterize = true
         layer.rasterizationScale = true ? UIScreen.main.scale : 1
     }
    
    
 }

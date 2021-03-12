//
//  ViewUtilities.swift
//  TudoNosso
//
//  Created by César Ganimi Machado on 07/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class ViewUtilities {
    
    
    static func setupCard(_ cardView: UIView!) {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.02
        cardView.layer.shadowOffset = .zero
        cardView.layer.shadowRadius = 20

        cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shouldRasterize = true
        cardView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    static func navigateToStoryBoard(storyboardName: String, storyboardID: String,window: UIWindow?){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    static func navigateToStoryBoard(storyboardName: String, storyboardID: String,window: UIWindow?, completion: (UIViewController)->()){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)

        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        completion(initialViewController)
    }
}

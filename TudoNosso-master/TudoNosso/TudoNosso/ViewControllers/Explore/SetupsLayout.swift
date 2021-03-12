//
//  setupsLayout.swift
//  TudoNosso
//
//  Created by Joao Flores on 05/12/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import UIKit

class SetupsLayout {
    
    func setupSearchBarLayout(searchController: UISearchController) -> UISearchController {
        
        let colText = UITextField.appearance()
        colText.textColor = .gray
        
        searchController.searchBar.placeholder = "Buscar"
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.barTintColor = UIColor(rgb: 0xFF5900, a: 1)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.isTranslucent = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }
    
    func setupNavegationBarLayout(navigationController: UINavigationController?) {
        navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xFF5900, a: 1)
        navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFF5900, a: 1)
        navigationController?.navigationBar.tintColor = UIColor(rgb: 0xFFFFFF, a: 1)
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    
}

//
//  UIViewController+extension.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 06/12/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func setupSearchBar(searchBarDelegate: UISearchBarDelegate, searchResultsUpdating: UISearchResultsUpdating, _ tableView: UITableView , _ searchController: UISearchController) {
        tableView.tableHeaderView = searchController.searchBar
        
        let colText = UITextField.appearance()
        colText.textColor = .gray
        searchController.searchBar.delegate = searchBarDelegate
        searchController.searchResultsUpdater = searchResultsUpdating
        
        searchController.searchBar.placeholder = NSLocalizedString("find", comment: "")
        if #available(iOS 13, *) {
            searchController.searchBar.searchTextField.backgroundColor = .bg
        }
        searchController.searchBar.barTintColor = UIColor(rgb: 0xFF5900, a: 1)
        searchController.searchBar.tintColor = .white //UIColor(rgb: 0xFF5900, a: 1)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
}

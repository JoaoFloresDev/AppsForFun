//
//  JobsTableViewHeader.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 08/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class JobsTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var circleView: RoundedView!
    @IBOutlet weak var titleLabel: UILabel!
    
    enum TypeOfHeader {
        case ongoing
        case finished
        
        var title: String {
            switch self {
            case .ongoing:  return "Em andamento"
            case .finished: return "Encerradas"
            }
        }
        
        var circleColor: UIColor {
            switch self {
            case .ongoing:  return UIColor(rgb: 0x82E148)
            case .finished: return UIColor.thinGray
            }
        }
        
        var height: CGFloat {
            switch self {
            case .ongoing:
                return CGFloat(50)
            case .finished:
                return CGFloat(30)
            }
        }
    }
    
    static let reuseIdentifer = String(describing: JobsTableViewHeader.self)
    
    static var nib: UINib {
        let nibName = String(describing: JobsTableViewHeader.self)
        return UINib(nibName: nibName, bundle: nil)
    }
    
    func configure(type: TypeOfHeader) {
        self.circleView.backgroundColor = type.circleColor
        self.titleLabel.text = type.title
    }
}



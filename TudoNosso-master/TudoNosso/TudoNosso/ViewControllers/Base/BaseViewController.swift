//
//  BaseViewController.swift
//  TudoNosso
//
//  Created by Bruno Cardoso Ambrosio on 06/12/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var isDarkStatusBar:Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDarkStatusBar ? .default : .lightContent
    }

}
